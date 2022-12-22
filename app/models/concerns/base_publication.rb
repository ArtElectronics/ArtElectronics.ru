module BasePublication
  extend ActiveSupport::Concern

  included do
    acts_as_taggable

    include TheImage
    include MainImage

    include BaseStates
    include HasMetaData
    include ActAsStorage
    include NestedSetMethods
    include CommonClassMethods

    include TheSimpleSort::Base
    include ThePagination::Base
    include TheComments::Commentable
    include TheNotification::LocalizedErrors

    include PublicationModeration
    include PublicationContentProcessing

    # Order is important for building of errors
    # Technical messages should be builded only
    # if we haven't user-friendly errors
    #
    ############################################
    # Order is important
    ############################################
    validates_presence_of :user, :title
    validates_presence_of :slug, if: ->{ errors.blank? }

    include TheFriendlyId::Base
    ############################################
    # ~ Order is important
    ############################################
    before_validation :define_user_via_hub, :define_hub_state, on: :create
    before_save       :prepare_tags, :set_published_at
    before_save       :set_ugc_flag, on: :create
    after_create      :recalculate_hub_counters!

    paginates_per 25

    # relations
    belongs_to :user
    belongs_to :hub

    scope :publication_access, ->(user = nil) { user ? for_manage : published }

    scope :for_yandex_news, -> {
      published.
      recent(:created_at).
      where(yandex_news: true).
      where("published_at >= ?", 8.days.ago.utc)
    }

    scope :for_flipboard_tech, -> {
      published.
      recent(:created_at).
      where(flipboard_tech: true).
      where("published_at >= ?", 14.days.ago.utc)
    }

    scope :for_flipboard_culture, -> {
      published.
      recent(:created_at).
      where(flipboard_culture: true).
      where("published_at >= ?", 14.days.ago.utc)
    }

    scope :for_surfingbird, -> {
      published.
      recent(:created_at).
      where(surfingbird: true).
      where("published_at >= ?", 14.days.ago.utc)
    }

    scope :for_novoteka, -> {
      published.
      recent(:created_at).
      where(novoteka: true).
      where("published_at >= ?", 2.month.ago.utc)
    }
  end

  def pub_at
    _pub_at = try(:published_at)
    _pub_at ? I18n.l(_pub_at, format: "%d %B %Y") : '&mdash;'
  end

  def comments_on?
    comments_switcher == 'on'
  end

  def comments_off?
    comments_switcher == 'off'
  end

  def root_hub
    hub.root_hub if hub
  end

  def update_attachment_fields att_name
    _self = self.class.find(self.id)

    %w[file_name content_type file_size updated_at].each do |field|
      field_name = "#{att_name}_#{field}"
      self.send "#{field_name}=", _self[field_name]
    end

    self
  end

  private

  def set_published_at
    # TODO: uncomments after release
    # self.published_at = self.created_at

    # Time.now
    # Time.current
    # Time.zone.now

    # DateTime.now
    # DateTime.now.in_time_zone

    if published? && published_at.blank?
      self.published_at = DateTime.now.in_time_zone
    end
  end

  def define_user_via_hub
    self.user = hub.user if hub && user.blank?
  end

  def define_hub_state
    self.hub_state = hub.state if hub
  end

  def recalculate_hub_counters!
    hub.recalculate_pubs_counters! if hub
  end

  # User Generated Content
  def set_ugc_flag
    unless user.has_role?(:moderator, self.class.table_name)
      self.ugc = true
    end
  end

  # TAGS ERROR "Институт "Стрелка"

  def prepare_tags
    AppConfig.tag_contexts.each do |context|
      if self.respond_to?( "#{context}_list" )
        tags = massage_tags( self.send( "#{context}_list" ) )
        assign_tags(context, tags)
      end
    end
  end

  def massage_tags tags
    # Replace dots with underscore, because it can brokes url_helpers (dot can be interpreted as format param)
    syms = Regexp.new '\.'
    tags = tags.to_s.mb_chars.gsub(syms, '_')
    tags = Sanitize.clean(tags, :elements => [])
  end

  def assign_tags context, tags
    self.send( "#{ context }_list"+'=', tags )
    self.send( "inline_#{ context }_tags=", tags )
  end
end
