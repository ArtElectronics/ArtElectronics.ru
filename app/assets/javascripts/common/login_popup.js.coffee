@popupCenter = (name, url, width, height) ->
  left = (screen.width  / 2) - (width  / 2)
  top  = (screen.height / 2) - (height / 2) - 50

  popup = window.open url, name, """
    menubar=no, toolbar=no, status=no,
    width=#{ width }, height=#{ height },
    left=#{ left }, top=#{ top }
  """

  do popup.focus

@oauth_processing = ->
  oauth_data = window.oauth_data
  data = json2data oauth_data
  form = $ '#signin'

  $('.app_preloader').fadeIn()

  if !data.length && data?.provider
    form.find('#oauth_data').val oauth_data

  form.submit()

@SocialLoginButtons = do ->
  init: ->
    $('.social_login a').click (e) ->
      btn = $ e.target

      popupCenter(
        "authPopup",
        btn.attr("href"),
        (btn.attr("data-width")  || 500),
        (btn.attr("data-height") || 500)
      )

      false
