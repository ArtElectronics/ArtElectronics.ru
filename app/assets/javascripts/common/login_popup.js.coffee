@popupCenter = (name, url, width, height) ->
  left = (screen.width  / 2) - (width  / 2)
  top  = (screen.height / 2) - (height / 2) - 50

  window.open url, name, """
    menubar=no, toolbar=no, status=no,
    width=#{ width }, height=#{ height },
    left=#{ left }, top=#{ top }
  """

$ ->
  $(".login-popup").click (e) ->
    btn = $ e.target

    popupCenter(
      "authPopup",
      btn.attr("action"),
      btn.attr("data-width"),
      btn.attr("data-height")
    )

    false
