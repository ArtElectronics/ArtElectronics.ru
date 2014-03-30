module SocialNetworksLogin
  extend ActiveSupport::Concern

  # TODO: refactor this ball of yarn
  included do
    has_many :credentials, autosave: true, dependent: :destroy

    before_validation :parse_oauth_params, on: :create, if: ->(user){ !user.oauth_params.blank? }
    before_validation :prepare_login, on: :create
    before_create     :skip_confirmation!,  if: ->(user){ !user.oauth_params.blank? }
    before_create     :calculate_signup_fields!
    after_create      :send_signup_notification, on: :create, if: ->(user){ !user.oauth_params.blank? && ( JSON.parse( CGI.unescapeHTML(user.oauth_params))['provider'] == 'facebook') }

    private

    def parse_oauth_params
      oa = JSON.parse( CGI.unescapeHTML(self.oauth_params), symbolize_names: true )
      
      uid = access_token = access_token_secret = expires_at = ''
      login = username = email = ''

      provider = oa[:provider]

      case provider
      when 'facebook'
        uid = oa[:uid]      
        access_token = oa[:credentials][:token]
        expires_at   = oa[:credentials][:expires_at]

        login    = oa[:info][:nickname]     
        username = oa[:info][:name]
        email    = oa[:info][:email]
      when 'twitter'
        uid = oa[:uid]     
        access_token        = oa[:credentials][:token]
        access_token_secret = oa[:credentials][:secret]

        login    = oa[:info][:nickname]     
        username = oa[:info][:name]
      when 'vkontakte'
        uid = oa[:uid]      
        access_token = oa[:credentials][:token]
        expires_at   = oa[:credentials][:expires_at]

        login    = oa[:info][:nickname]     
        username = oa[:info][:name]
      end

      self.credentials.build uid: uid, 
                             provider: provider, 
                             access_token: access_token,
                             access_token_secret: access_token_secret,
                             expires_at: expires_at
      
      login.blank? ? self.login = username : self.login = login
      prepare_login    
      self.login = fake_login( self.login ) # faked if double 
      
      if email.blank? # in twitter
        email      = access_token[-5,5]+'@fk.fk' 
        self.email = fake_email( FAKE_EMAIL_PREFIX+'_0_'+ email )
      else
        # TODO: Не регистрировать, а впустить юзера, так как его email уже есть в базе. Например он зарегался через обычную учетку.
        self.email = email
      end
      
      self.username = username
      self.password = access_token[0..25]
    end

    def fake_login login
      reg = /-(\d+$)/
      postfix = login.match(reg)
      postfix.nil? ? next_id = 1 : next_id = postfix[1].to_i+1

      u = User.where(login: login).first
      if u.nil? 
        login
      else
        fake_login( postfix.nil? ? login+="-#{next_id}" : login.sub!( reg,"-#{next_id}" ))
      end
    end

    def fake_email email
      reg = /^#{FAKE_EMAIL_PREFIX}_(\d+)_/
      num = email.match(reg)
      next_id = num[1].to_i+1

      u = User.where(email: email).first
      if u.nil?
        email
      else
        fake_email( email.sub!( reg,"#{FAKE_EMAIL_PREFIX}_#{next_id}_" ))
      end
    end

    # notification for oauth
    def send_signup_notification    
      send_devise_notification(:signup_congratulation, {})
    end
  end
end