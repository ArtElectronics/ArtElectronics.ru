# render json: { flash: { alert: "Hello World!" } },       status: 422
# render json: { errors: { x: ["hello"], y: ["world"] } }, status: 422
# render json: { error: 'Error Message' },                 status: 422

@JodyNotification = do ->
  clean: ->
    $('div.toast').remove()

  show_error: (error) ->
    TheNotification.show_error(error)

  show_errors: (errors) ->
    TheNotification.show_errors(errors)

  show_flash: (flash) ->
    TheNotification.show_flash flash

  processor: (data) ->
    JodyNotification.clean() unless data?.keep_alerts

    JodyNotification.show_errors data.errors
    JodyNotification.show_error  data.error
    JodyNotification.show_flash  data.flash

# Redirect processor
@JodyRedirect = do ->
  reload:                 -> do location.reload
  to:               (url) -> window.location.href  = url
  location_replace: (url) -> window.location.replace url

  exec: (data) ->
    @reload()              if data.page_reload
    @to rurl               if rurl = data.redirect_to
    @location_replace lurl if lurl = data.location_replace

@JodyHtml = do ->
  processor: (data) ->
    @html_content_replace(data)
    @html_content_append(data)
    @change_attrs(data)

  html_content_replace: (data) ->
    if selectors = data?.html_content?.replace
      for selector, content of selectors
        $(selector).html content

  html_content_append: (data) ->
    if selectors = data?.html_content?.append
      for selector, content of selectors
        $(selector).append content

  change_attrs: (data) ->
    # ADD
    if add_attrs = data?.html_content?.change_attrs?.add
      for id, attrs of add_attrs
        if (item = $ id).length
          for attr_name, val of attrs
            original_value = item.attr(attr_name) || ''
            item.attr(attr_name, "#{ original_value } #{ val }")

    # REMOVE
    if remove_attrs = data?.html_content?.change_attrs?.remove
      for id, attrs of remove_attrs
        if (item = $ id).length
          for attr_name, val of attrs
            original_value = item.attr(attr_name) || ''
            item.attr attr_name, original_value.replace(val, '')

    # REPLACE
    if replace_attrs = data?.html_content?.change_attrs?.replace
      for id, attrs of replace_attrs
        if (item = $ id).length
          for attr_name, val of attrs
            item.attr(attr_name, val)

    # DELETE
    if delete_attrs = data?.html_content?.change_attrs?.delete
      for id, attrs of delete_attrs
        if (item = $ id).length
          for attr_name, val of attrs
            item.removeAttr attr_name

@JodyJS = do ->
  processor: (data) ->
    @js_functions_invoke(data)

  js_functions_invoke: (data) ->
    if fus = data?.js_function_invoke
      for fu, args of fus
        if _fu = @predefined_fu(fu)
          log fu, args
          _fu(args)
    true

  predefined_fu: (fu_path) ->
    fu = window
    fu_path = fu_path.split '.'

    for part in fu_path
      (fu = null; break) unless fu[part]
      (fu = fu[part])
    fu

# JODY: Json for dynamic sites
# Миддлвара, которая умеет разбирать приходящий JSON
# и делать кучу рутинной работы, вроде показа нотификаций
# и изменения кусков html
@JODY = do ->
  processor: (data) ->
    JodyNotification.processor(data)
    JodyHtml.processor(data)
    JodyRedirect.exec(data)
    JodyJS.processor(data)

  error_processor: (xhr, response, status) ->
    JodyNotification.clean()

    if typeof (data = json2data(response.responseText, _default = NaN)) is "object"
      JodyNotification.processor(data)
    else
      if (response.status isnt 0) and (response.status isnt 200)
        JodyNotification.show_error("#{ response.statusText }: #{ response.status }")

  # JODY/AJAX remote
  ajax_success: (xhr, data, status, response) ->
    JodyNotification.processor(data)
    JodyHtml.processor(data)
    JodyRedirect.exec(data)
    JodyJS.processor(data)

  ajax_error: (xhr, response, status, message) ->
    @error_processor(xhr, response, status)

  remote_forms_init: ->
    JODY_forms = $ '@JODY_form'

    JODY_forms.on 'ajax:success', (xhr, data, status, response) ->
      JODY.ajax_success(xhr, data, status, response)

    JODY_forms.on 'ajax:error', (xhr, response, status, message) ->
      JODY.ajax_error(xhr, response, status, message)

# @JodyModal = do ->
#   processor: (data) ->
#     if data?.modal?.hide is true
#       $('.modal').modal 'hide'

# @JodyForm = do ->
#   processor: (xhr, data, status) ->
#     return false unless (form = $ xhr.currentTarget).is('form')
#     do form[0].reset if data?.form?.reset is true
