@MultipleFileUpload = do ->
  init: ->
    $("@multiple_file_upload").fileupload
      type:      'POST'
      dataType:  'JSON'
      paramName: 'file'
      dropZone: $('#drug_and_drop_files')

      add: (e, uploader) ->
        uploader.submit()

      submit: (e, uploader) ->
        # log "Submiting"

      send: (e, uploader) ->
        # log "Uploading"

      fail: (e, uploader) ->
        # log "Failed"
        # result = $ uploader.jqXHR.responseText

      done: (e, uploader) ->
        JODY.ajax_success(uploader.jqXHR, uploader.result, uploader.jqXHR.status, uploader.jqXHR.responseJSON)
        # log "Done"
        # result = $ uploader.result

      progress: (e, data) ->
        # progress = parseInt data.loaded / data.total * 100, 10
        # log "Progress: #{ progress }"

      progressall: (e, data) ->
        progress = parseInt data.loaded / data.total * 100, 10
        progress_bar   = $('@files-uploading-progress-bar')

        if progress < 100
          size = "#{ progress }%"
          progress_bar.show()
          progress_bar.css { width: size }
        else
          progress_bar.hide()
          progress_bar.css { width: '1%' }

        # log "ProgressAll: #{ progress }"
