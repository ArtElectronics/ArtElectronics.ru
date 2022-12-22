@show_tatlin_manual = ->
  manual_holder = $('.special_post_manual')
  manual_close  = $('.close_special_manual')
  h = $('.body').height()
  manual_holder.css { height: h }

  manual_holder.fadeIn()
  manual_close.click -> manual_holder.fadeOut()

@show_tatlin = ->
  width  = '100%'
  height = 670

  iframe = $("""<iframe
    name='Tatlin'
    class='html_special_post'
    scrolling='no'
    width='#{ width }'
    height='#{ height }'
    hspace='0'
    vspace='0'
    marginheight='0'
    marginwidth='0'
  >""")

  wrp = $("<div class='tatlin_wrp'>")
  iframe.attr('src', "/special_posts/tatlin/index.html")
  $("#viewer").append wrp.append iframe
  FlashViewer.show_viewer()
