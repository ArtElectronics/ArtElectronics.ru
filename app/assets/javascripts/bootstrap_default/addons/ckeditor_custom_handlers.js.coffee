$ ->
  CKEDITOR.on 'dialogDefinition', (ev) ->
    dialogName = ev.data.name
    dialogDefinition = ev.data.definition

    if dialogName is 'link'
      advTab = dialogDefinition.getContents('advanced')
      advRel = advTab.get('advRel')
      advRel.default = 'nofollow'

    if dialogName is 'image'
      pub_title = $('@pub_title').val()

      infoTab = dialogDefinition.getContents('info')
      advTab  = dialogDefinition.getContents('advanced')

      alt_text = infoTab.get('txtAlt')
      alt_text.default = pub_title

      advTitle = advTab.get('txtGenTitle')
      advTitle.default = pub_title
