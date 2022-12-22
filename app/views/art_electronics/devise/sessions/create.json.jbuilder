json.flash do
  if current_user
    json.info "Выполнен вход в систему"
  else
    json.error "Не удалось войти в систему.<br>Попробуйте еще раз"
  end
end

# json.location_replace "/"
json.redirect_to cabinet_url if current_user
