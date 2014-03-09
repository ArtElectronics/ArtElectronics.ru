module BasePublication
  extend ActiveSupport::Concern

  included do
    acts_as_taggable

    include BaseSorts
    include BaseStates
    include ActAsStorage
    include TheFriendlyId
    include NestedSetMethods
    include CommonClassMethods
    include MainImageUploading
    include TheComments::Commentable

    before_validation :define_user_via_hub, :define_hub_state, on: :create
    before_save       :prepare_tags, :prepare_content, :set_published_at
    after_create      :recalculate_hub_counters!

    paginates_per 25

    # relations
    belongs_to :user
    belongs_to :hub

    validates_presence_of   :user, :slug, :title
  end

  def localized_errors
    errors.inject({}) do |hash, (k, v)|
      k = self.class.human_attribute_name k
      hash[k] = v
      hash
    end
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
    self.published_at = self.created_at
    # self.published_at = Time.now if published? && published_at.blank?
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

  def to_textile txt
    RedCloth.new(txt.to_s).to_html
  end

  def prepare_tags
    # Rm dots, because it can brokes url_helpers (dot can be interpreted as format param) 
    syms = %w[' " ` : \. \\ /].join('|')
    syms = Regexp.new syms

    tags = self.tag_list.to_s.mb_chars.downcase.gsub(syms, ',')
    tags = Sanitize.clean(tags, :elements => [])

    self.tag_list    = tags
    self.inline_tags = self.tag_list.to_s
  end

  def prepare_content
    self.intro   = to_textile(raw_intro)
    self.content = to_textile(raw_content)
  end
end