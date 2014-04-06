@SearchForm = do ->
  init: ->
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