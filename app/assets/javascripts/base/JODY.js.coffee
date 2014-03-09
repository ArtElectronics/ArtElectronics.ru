# JODY - JsOn for DYnamic sites
# Mediator component for rails
$(document).ajaxError (event, request, settings) ->
  # ajax error processing should be here
  if typeof (data = request.responseJSON) is "object"
    flash = data.flash
    errors = data.errors

$(document).ajaxSuccess (event, xhr, params, data) ->
  # ajax siccess processing should be here