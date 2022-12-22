TheRole.configure do |config|
  config.destroy_strategy  = nil
  config.default_user_role = :blogger
  config.layout            = :bootstrap_default
  config.first_user_should_be_admin = true
end
