class MailerPreview < ActionMailer::Preview
  def confirmation_instructions
    DeviseMailer.confirmation_instructions(User.last, {})
  end
end
