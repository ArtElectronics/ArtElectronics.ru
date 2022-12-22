class DeviseMailer < Devise::Mailer
  helper MailMarkupHelper

  def headers_for(action, opts)
    # Add Admin on copy
    _headers = super
    _headers[:template_path].unshift('art_electronics/devise/mailer')
    _headers
  end
end
