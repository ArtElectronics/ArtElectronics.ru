json.replace_html do |div|
  div.set! '.sessions.new', render(partial: 'account_should_be_activate.html')
end

json.app_preloader :hide
