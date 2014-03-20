$ ->
  $('a.flash_version').click ->
    show_viewer()

$ ->
  $('a#viewer_close_message').click ->
    hide_viewer()
    
show_viewer = ->
  $('.viewer_block').show()
  # hide_alternative_content()

hide_viewer = ->
  $('.viewer_block').hide()
  # show_alternative_content()

# TODO
# @viewer_height = 840 set in  articles/show.html.haml
#
#hide_alternative_content = ->
  # $('.body.container').css('overflow', 'hidden')

#show_alternative_content = ->
#  $('.body.container').css('overflow', 'visible');
