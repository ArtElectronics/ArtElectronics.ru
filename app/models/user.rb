class User < ActiveRecord::Base
  attr_accessor :oauth_params

  devise :database_authenticatable,
    # :confirmable,
    :recoverable,
    :validatable,
    :registerable,
    :rememberable,
    :omniauthable,
    :omniauth_providers => [:facebook, :twitter, :vkontakte]

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
  has_one  :author, validate: true, dependent: :nullify

  # Validations
  validates :login,  presence: true, uniqueness: true

  include SocialNetworksLogin

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

  # notification for manual registration
  def after_confirmation
    send_devise_notification(:signup_congratulation, {})
  end
end
