@Header = do ->
  init: ->
    do @menus_init
    do @search_bar_init
    do @search_form_init
    do @hide_menus_on_any_body_click

  menus_init: ->
    header = $ 'header'
    $(".magazine, .about", header).on 'click', (e) ->
      holder = $ e.currentTarget

      $('nav', header).addClass 'hidden'
      $('li',  header).not(holder).removeClass 'current'
      holder.toggleClass 'current'

      if holder.hasClass 'current'
        $('nav', holder).removeClass 'hidden'
      else
        $('nav', holder).addClass 'hidden'

  hide_menus_on_any_body_click: ->
    $(document).click (e) ->
      target = $ e.target
      menu   = '.magazine nav'
      about  = '.about nav'

      unless target.parents('.magazine').length
        menu = $ menu
        $('header .magazine').removeClass 'current'
        menu.addClass 'hidden' if menu.is(":visible")

      unless target.parents('.about').length
        about = $ about
        $('header .about').removeClass 'current'
        about.addClass 'hidden' if about.is(":visible")

  search_bar_init: ->
    header = $ 'header'

    $('.js-search-btn', header).on 'click', (e) ->
      holder = $ e.currentTarget
      $('.js-search-bar').toggleClass 'hidden'

  search_form_init: ->
    form = by_role 'search'

    form.on 'submit', ->
      url   = form.attr('action')
      query = by_role 'search_query'
      posts = by_role 'search_posts'
      blogs = by_role 'search_blogs'

      query = query.val()
      p = posts.is(':checked')
      b = blogs.is(':checked')

      url = [url, query].join '/'

      params = []
      params.push "sp=✓" if p
      params.push "sb=✓" if b
      params = params.join('&')

      url = [url, params].join('?') if params.trim().length > 0
      form.attr('action', url)
