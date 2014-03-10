# JODY - JsOn for DYnamic sites
# Mediator component for rails

Redirect = do ->
  to:               (url) -> window.location.href  = url
  location_replace: (url) -> window.location.replace url

  exec: (data) ->
    @to rurl               if rurl = data.redirect_to
    @location_replace lurl if lurl = data.location_replace

$(document).ajaxError (event, request, settings) ->
  log "JODY: Ajax error"

  if typeof (data = request.responseJSON) is "object"
    flash  = data.flash
    errors = data.errors

    TheNotification.show_flash  flash
    TheNotification.show_errors errors

    Redirect.exec data

$(document).ajaxSuccess (event, xhr, params, data) ->
  log "JODY: Ajax success"

  flash  = data.flash
  errors = data.errors

  TheNotification.show_flash  flash
  TheNotification.show_errors errors

  Redirect.exec data