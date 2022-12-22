class SpecialPostsMailer < ActionMailer::Base
  default from: "robot@artelectronics.ru"

  def tatlin_postcard email="test@test.com", name="", image_path=""
    @name = name
    attachments.inline['postcard.png'] = File.read(image_path)

    mail(
      to: email,
      subject: "Открытка: Futute-text: Владимир Татлин",
      template_path: "art_electronics/special_posts",
      template_name: "tatlin_postcard"
    )
  end
end
