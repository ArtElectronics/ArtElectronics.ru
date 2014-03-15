class User < ActiveRecord::Base
  attr_accessor :oauth_params

  devise :database_authenticatable, :omniauthable, :confirmable, :recoverable, :registerable, :rememberable, :validatable, :omniauth_providers => [:facebook, :twitter, :vkontakte]

  include TheRole::User
  
  include ActAsStorage
  include HasAttachedFiles

  include TheComments::User
  include TheComments::Commentable

  def to_param; self.login end

  # Relations
  has_many :hubs
  has_many :pages
  has_many :posts
  has_many :credentials, :autosave => true, dependent: :destroy
  has_one  :author, validate: true, dependent: :nullify

  # Validations
  validates :login,  presence: true, uniqueness: true

  # Filters
  before_validation :parse_oauth_params, on: :create, 
                if: ->(user){ !user.oauth_params.blank? }
  before_validation :prepare_login, on: :create
  
  before_create :skip_confirmation!, 
                if: ->(user){ !user.oauth_params.blank? }
  before_create :calculate_signup_fields!

  after_create :send_signup_notification, on: :create, 
                if: ->(user){ !user.oauth_params.blank? && ( JSON.parse( CGI.unescapeHTML(user.oauth_params))['provider'] == 'facebook')}

  # comment, because mysql error: "index_users_email dublicate email key". Для решения проблемы с отсутствием email в oauth втиттера и вконтакте. я создаю fake_email
  # # override devise method for disable devise email validation when oauth authentication flow
  # def email_required?
  #   !self.oauth_params.blank? ? false : super
  # end

  class << self
    def root
      @@root ||= User.first
    end
  end

  def admin?
    self == User.root
  end

  # TheComments methods
  def comments_admin?
    self == User.root
  end

  def comments_moderator? comment
    admin? || id == comment.holder_id
  end

  def commentable_title
    login
  end

  def commentable_path
    [self.class.to_s.tableize, login].join('/')
  end
  # ~ TheComments methods

  def role_name
    role.try(:name)
  end

  def recalculate_all_attached_files!
    # Recalculate all user counters here
  end

  # Select an available hubs
  # 
  # Admin has: all + for_manage hubs
  #
  # Any User has: hubs defined in his TheRole
  # with section "available_hubs"
  def available_hubs object = nil
    return Hub.none if object.nil?

    ctrl_name = object.ctrl_name
    scope = ctrl_name.blank? ? :all : [:of_, ctrl_name]

    return Hub.send(*scope).for_manage if admin?
    
    section = role.to_hash.try(:[], 'available_hubs')
    return Hub.none if section.blank?

    keys = section.select{|k, v| v == true }.keys
    keys.map!{|item| item.to_slug_param }

    Hub.friendly_where(keys).published_set.send(*scope)
  end

  private

  def prepare_login
    self.login = self.login.to_s.to_slug_param
  end

  def calculate_signup_fields!
    self.role = Role.with_name(:blogger) if self.role.nil?
  end

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
  
  protected

  # notification for manual registration
  def after_confirmation
    send_devise_notification(:signup_congratulation, {})
  end
end
