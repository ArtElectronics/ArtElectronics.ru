@by_role = (name) -> $ """[data-role='#{ name }']"""

# Add `@data-role` alias to jQuery.
# Copy from jquery.role by Sasha Koss https://github.com/kossnocorp/role

rewriteSelector = (context, name, pos) ->
  original = context[name]
  return unless original
  context[name] = ->
    arguments[pos] = arguments[pos].replace(/@@([\w\u00c0-\uFFFF\-]+)/g, "[data-block~=\"$1\"]")
    arguments[pos] = arguments[pos].replace(/@([\w\u00c0-\uFFFF\-]+)/g, "[data-role~=\"$1\"]")
    original.apply context, arguments

  $.extend context[name], original
  return

rewriteSelector $, "find", 0
rewriteSelector $, "multiFilter", 0

rewriteSelector $.find, "matchesSelector", 1
rewriteSelector $.find, "matches", 0
