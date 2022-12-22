@FlashViewer = do ->
  show_viewer: ->
    $('.viewer_block').show()

  hide_viewer: ->
    $('.viewer_block').hide()

  init: ->
    $('a.flash_version').click =>
      do @show_viewer
      false

    $('a.viewer_close_message').click =>
      do @hide_viewer
      false

    flashvars = attributes = {}

    parameters =
      bgcolor: '#ffffff'
      quality: 'high'
      allowScriptAccess: 'sameDomain'
      allowFullScreen: 'false'
      wmode: 'opaque'
    
    viewer_height = $(window).height()
    
    data_swf_url  = $('.viewer_block').data('swf-url')
    data_swf_type = $('.viewer_block').data('swf-type')

    if data_swf_type is 'swf_see'
      data_swf_url = "/swf/see.swf?obj_url=#{ data_swf_url }"

    swfobject.embedSWF(data_swf_url, 'viewer', '100%', '100%', '9.0.0', false, flashvars, parameters, attributes);

    if data_swf_type is 'swf'
      $('.flash_version').click()
