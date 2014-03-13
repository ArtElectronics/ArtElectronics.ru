class User < ActiveRecord::Base
  attr_accessor :oauth_params

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

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
  after_create :calculate_signup_fields!
  after_create :send_confirmation
  before_validation :parse_oauth_params, on: :create, if: ->(user){!user.oauth_params.blank? }  
  before_validation :prepare_login, on: :create

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
    # OPTIMIZE: здесь пока доинициализация (после devise) нового пользователя,
    # так как он не все нужные мне поля   устанавливает по default
    if self.role != Role.with_name(:admin)
      # part = self.email.split('@')[0].to_s.to_slug_param

      # self.login    = part if self.login.blank?
      # self.username = part if self.username.blank?
      self.role     = Role.with_name :blogger

      self.save
    end
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
      # access_token = oa[:credentials][:token]
      # expires_at   = oa[:credentials][:expires_at]

      login    = oa[:info][:nickname]     
      username = oa[:info][:name]
      # email    = oa[:info][:email]
    end

    self.credentials.build uid: uid, 
                   provider: provider, 
                   access_token: access_token, 
                   expires_at: expires_at

    self.login    = login
    self.username = username
    self.email    = email
    self.password = access_token[0..25]
  end
end

def send_confirmation
  UserNotiferMailer.test_mail.deliver
end
