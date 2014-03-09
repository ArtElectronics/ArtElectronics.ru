@App = do ->
  env: do ->
    _env: ->
      return env if env = window.APP_ENV
      window.APP_ENV = document.getElementById('env_token')?.attributes?.content?.value

    name: (env = 'undefined_env') -> @_env() is env
    development: -> @name('development')
    production:  -> @name('production')
    staging:     -> @name('staging')