json.flash do
  json.info "Пользователь зарегистрирован"
end

json.redirect_to cabinet_url
json.app_preloader :hide
