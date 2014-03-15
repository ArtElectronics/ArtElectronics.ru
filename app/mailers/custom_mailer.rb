class CustomMailer < Devise::Mailer
  
  def signup_congratulation(record, token, opts={})
    devise_mail(record, :signup_congratulation, opts)
  end
end
