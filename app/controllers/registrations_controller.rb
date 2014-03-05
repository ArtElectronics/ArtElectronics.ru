class RegistrationsController < Devise::RegistrationsController  
  
  def test_mail
    UserNotiferMailer.test_mail.deliver
    render nothing: true
  end
end
