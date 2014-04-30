$ ->
  contexts = $('#tags').data 'contexts'
  
  for c in contexts
    id = '#post_' + c + '_list'
    t = $( id ).data('tags')
    $( id ).select2( { tags: t, width: '100%' } )
