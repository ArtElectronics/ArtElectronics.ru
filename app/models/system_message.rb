class SystemMessage < ActiveRecord::Base
  TYPES = %w[
    user_registration
    credentials_created
    comment_created
    post_created blog_created page_created
  ]

  validates :message_type, presence: true
  validate  :message_type_name

  class << self
    def create_publication(user, publication)
      self.create(
        message_type: "#{ publication.class.to_s.downcase }_created",
        message: "Пользователь Login: #{ user.login }, Name: #{ user.username } создал новую публикацию #{ publication.class.to_s } => #{ publication.title }"
      )
    end

    def create_user_registration(user)
      self.create(
        message_type: 'user_registration',
        message: "Был зарегистрирован новый пользователь Login: #{ user.login }, Name: #{ user.username }"
      )
    end

    def create_credentials_for_user(user, provider)
      self.create(
        message_type: 'credentials_created',
        message: "Пользователь Login: #{ user.login }, Name: #{ user.username } привязал свою учетную запись к #{ provider }"
      )
    end
  end

  private

  def message_type_name
    unless TYPES.include?(message_type)
      errors.add(:message_type, "Undefined message type")
    end
  end
end
