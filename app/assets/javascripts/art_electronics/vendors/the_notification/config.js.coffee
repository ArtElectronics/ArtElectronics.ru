TheNotification.show_errors = (errors) ->
  for field, errs of errors
    for err in errs
      toastr.error "<b>#{ field }:</b> #{ err }"

TheNotification.show_flash = (flash) ->
  fu = { notice: 'info', error: 'error', warning: 'warning' }

  for level, msg of flash
    method = fu[level]
    toastr[method] msg

TheNotification.show_notifications = ->
  data = window.the_notifications
  return false unless data

  @show_errors errors if errors = data.errors
  @show_flash  flash  if flash  = data.flash