@TagsContexts = do ->
  init: ->
    if $('[data-contexts]').length
      contexts = $('#tags').data 'contexts'

      for model in ['post', 'blog']
        for context in contexts
          item = $ "##{ model }_#{ context }_list"
          tags = item.data('tags')
          item.select2
            tags: tags
            width: '100%'
