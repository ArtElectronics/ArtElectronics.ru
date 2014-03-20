$ ->
  $('a.flash_version').click ->
    show_viewer()
    return false

$ ->
  $('a#viewer_close_message').click ->
    hide_viewer()
    return false
    
show_viewer = ->
  $('.viewer_block').show()
  # hide_alternative_content()

hide_viewer = ->
  $('.viewer_block').hide()
  # show_alternative_content()

#hide_alternative_content = ->
  # $('.body.container').css('overflow', 'hidden')

#show_alternative_content = ->
  # $('.body.container').css('overflow', 'visible');

$ ->
  flashvars = {}
  attributes = {}
  parameters = {}
  parameters.bgcolor = '#ffffff'
  parameters.quality = 'high'
  parameters.allowScriptAccess = 'sameDomain'
  parameters.allowFullScreen = 'false'
  
  viewer_height = $(window).height()
  
  data_swf_url = $('.viewer_block').data('swf-url')
  data_swf_type = $('.viewer_block').data('swf-type')

  if data_swf_type == 'swf_see'
    data_swf_url = "/swf/see.swf?obj_url=#{data_swf_url}"

  swfobject.embedSWF(data_swf_url, 'viewer', '100%', viewer_height, '9.0.0', false, flashvars, parameters, attributes);

  if data_swf_type == 'swf'
    $('.flash_version').click()