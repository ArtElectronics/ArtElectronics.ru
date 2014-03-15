class RegistrationsController < Devise::RegistrationsController  

# один из вариантов отсылки notification email  
  # def create
  #   super
  #   if @user.persisted?
  #     test_mail
  #     # UserMailer.new_registration(@user).deliver
  #   end
  # end


  # def test_mail
  #   UserNotiferMailer.test_mail.deliver
  #   # render nothing: true
  # end
end
