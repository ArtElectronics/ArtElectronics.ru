# include PublicationModeration

module PublicationModeration
  extend ActiveSupport::Concern

  included do
    scope :banned,      -> { where(moderation_state: :banned)      }
    scope :moderated,   -> { where(moderation_state: :moderated)   }
    scope :unmoderated, -> { where(moderation_state: :unmoderated) }
  end

  def update_moderation_info current_user
    return unless current_user

    is_moderator = current_user.moderator?(self.class.table_name)

    if is_moderator
      if changes[:moderator_note] || changes[:moderation_state]
        self.moderated_at = Time.now
      end

      if current_user.id == self.user_id
        self.moderation_state = 'moderated'
      end
    end
  end

  def banned?
    moderation_state == 'banned'
  end

  def moderated?
    moderation_state == 'moderated'
  end

  def unmoderated?
    moderation_state == 'unmoderated'
  end

  # Bang! Bang! methods

  def ban!
    self.moderation_state = 'banned'
    save
  end

  def moderate!
    self.moderation_state = 'moderated'
    save
  end

  def unmoderate!
    self.moderation_state = 'unmoderated'
    save
  end

  # # blocked | approved
  # included do
  #   state_machine :moderation_state, namespace: :moderation, :initial => :unmoderated do
  #     event :to_unmoderated do
  #       transition all => :unmoderated
  #     end

  #     event :to_moderated do
  #       transition all => :moderated
  #     end

  #     event :to_blocked do
  #       transition all => :blocked
  #     end

  #     after_transition any => :blocked do |obj|
  #       p "transition => blocked - cleanup moderator notes"
  #     end
  #   end
  # end

end
