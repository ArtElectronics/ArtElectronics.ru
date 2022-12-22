class TestMailer < ActionMailer::Base
  default from: "robot@artelectronics.ru"

  # TestMailer.test_mail.deliver
  def test_mail
    mail(
      to: 'zykin-ilya@ya.ru',
      subject: "Тестовое письмо",
      template_path: "mailers",
      template_name: "test"
    )
  end
end
