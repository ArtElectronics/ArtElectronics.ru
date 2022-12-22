class User < ActiveRecord::Base
  devise :database_authenticatable,
    :confirmable,
    :recoverable,
    :validatable,
    :registerable,
    :rememberable,
    :omniauthable,
    :omniauth_providers => %w[ facebook twitter vkontakte google_oauth2 ]

  include UserAvatar
  include HasMetaData
  include TheRole::User

  include TheSimpleSort::Base
  include ThePagination::Base

  include TheComments::User
  include TheComments::Commentable

  include ActAsStorage
  include HasAttachedFiles

  include SocialNetworksLogin
  include UserSoialNetworksValidation
  include TheNotification::LocalizedErrors

  before_validation :create_default_login, on: :create
  before_validation :prepare_login

  def to_param; self.login end

  # Relations
  has_many :hubs
  has_many :pages
  has_many :posts
  has_many :blogs
  has_one  :author, validate: true, dependent: :nullify

  # Validations
  validates :login, presence: true, uniqueness: true
  validate  :login_chars_required

  def login_chars_required
    errors.add(:login, "должен содержать хотя бы один символ") unless (self.login =~ /[a-zA-Z]/mix)
  end

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

    ctrl_name = object.ctrl_name                        # posts
    scope = ctrl_name.blank? ? :all : [:of_, ctrl_name] # [:of_, :posts]

    return Hub.send(*scope).for_manage if admin?        # Hub.of_posts

    section = role.to_hash.try(:[], 'available_hubs')
    return Hub.none if section.blank?

    keys = section.select{|k, v| v == true }.keys
    keys.map!{|item| item.to_slug_param }

    Hub.friendly_where(keys).published_set.send(*scope)
  end

  # articles, blogs, pages
  def editable_hubs_for section_name = nil
    return Hub.none unless section_name

    top_hub = Hub.where(slug: section_name).first
    return Hub.none unless top_hub

    pub_scope = admin? ? :published : :all
    top_hub.self_and_descendants.send(pub_scope)
  end

  private

  def create_default_login
    _login = "user-#{ SecureRandom.hex[0..4] }"
    self.login = self.login.blank? ? _login : self.login
  end

  def prepare_login
    self.login = self.login.to_s.to_slug_param
  end

  def calculate_signup_fields!
    self.role = Role.with_name(:blogger) if self.role.nil?
  end
end
