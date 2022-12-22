@CkeditorOnPage = do ->
  init: ->
    if $('#redactor_intro').length
      CKEDITOR.replace 'redactor_intro', { height: 200 }

    if $('#redactor_content').length
      CKEDITOR.replace 'redactor_content', { height: 500 }
