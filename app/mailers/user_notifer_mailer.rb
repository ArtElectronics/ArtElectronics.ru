class UserNotiferMailer < ActionMailer::Base
  default from: "from@example.com"

  def test_mail
    @user = User.first
    @url = 'ya.ru'
    mail(to: 'densomart@gmail.com', subject: 'Hello world '+Time.now.to_s)
  end
end
