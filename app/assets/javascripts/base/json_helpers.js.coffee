@json2data = (str, _default = []) ->
  try
    JSON.parse str
  catch e
    log str
    log "JSON parse error: #{ e }"
    _default

@data2json = (data, _default = '[]') ->
  try
    JSON.stringify data
  catch e
    log data
    log "JSON stringify error: #{ e }"
    _default
