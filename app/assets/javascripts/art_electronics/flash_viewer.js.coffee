$ ->
  $('a.flash_version').click ->
    show_viewer()

$ ->
  $('a#viewer_close_message').click ->
    hide_viewer()
    
show_viewer = ->
  $('.viewer_block').show()
#  $(window).scrollTop(325)
  hide_alternative_content()

hide_viewer = ->
  $('.viewer_block').hide()
#  $(window).scrollTop(200)
  show_alternative_content()

# TODO
# @viewer_height = 840 set in  articles/show.html.haml
#
hide_alternative_content = ->
#  $('.body.container').css('margin-top', '180px')
  $('.body.container').css('overflow', 'hidden')
#  $('.body.container').css('height', '#{840 - 40}px')

show_alternative_content = ->
  $('.body.container').css('margin-top', '0px');
  $('.body.container').css('overflow', 'visible');
  $('.body.container').css('height', 'auto');

###

  $('#sidebar, .tmp_slider_wrap').show() 

  $('#sidebar, .tmp_slider_wrap').hide()

  $('.swf_txt_content').show()

  $('.swf_txt_content').hide();

function hide_viewer(){
  $('.viewer_block').hide();
  $('.swf_txt_content').hide();
  $(window).scrollTop(200);
  show_alternative_content();
}

function show_viewer(){
  $('.viewer_block').show();
  $('.swf_txt_content').show();
  $(window).scrollTop(325);
  hide_alternative_content();
}
function hide_alternative_content(){
  $('#sidebar, .tmp_slider_wrap').hide()
  $('#alternative_content').css('margin-top', '180px')
  $('#alternative_content').css('overflow', 'hidden')
  $('#alternative_content').css('height', '#{@viewer_height - 40}px');
function show_alternative_content(){
  $('#sidebar, .tmp_slider_wrap').show()
  $('#alternative_content').css('margin-top', '0px');
  $('#alternative_content').css('overflow', 'visible');
  $('#alternative_content').css('height', 'auto'); 
}
###