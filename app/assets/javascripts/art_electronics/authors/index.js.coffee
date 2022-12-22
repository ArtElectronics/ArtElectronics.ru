@AuthorsList = do ->
  init: ->
    $(document).on 'click', '.author .more_additional_posts', (e) ->
      link   = $ e.target
      holder = link.parents(".author")
      item   = $(".additional_posts", holder)

      if item.is(':visible')
        item.slideUp()
      else
        item.slideDown()

      false

    $(document).on 'click', '.author .more', (e) ->
      link   = $ e.target
      holder = link.parents(".author")
      item   = $(".info", holder)

      if item.is(':visible')
        item.slideUp()
      else
        item.slideDown()

      false

