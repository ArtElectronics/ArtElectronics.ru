# friendly_id h11149+menu-10-u-5  # uniq
# short_id    h11149              # uniq
# id          50                  # uniq

module TheFriendlyId
  extend ActiveSupport::Concern

  SEPARATOR = "+"

  def self.int? str
    str.to_s.to_i.to_s == str
  end

  def self.friendly? str
    Regexp.new("\\#{TheFriendlyId::SEPARATOR}") =~ str
  end

  def TheFriendlyId.short? str
    str =~ /^[A-Z]+[0-9]+$/mix
  end

  included do
    def to_param; self.friendly_id end

    validates_presence_of   :short_id, :friendly_id
    validates_uniqueness_of :short_id

    before_validation :build_short_id
    before_validation :build_slugs

    def build_short_id
      return unless self.short_id.blank?
      klass  = self.class.to_s.downcase.to_sym

      prefix = {
        hub:     :h,
        page:    :p,
        post:    :pt,
        blog:    :b,
      }[klass]

      # build short id
      prefix  ||= 'x'
      rnd_num   = 9999
      short_id  = [prefix, rand(rnd_num)].join

      # rebuild if find identically short_id
      try_counter = 0
      while self.class.where(short_id: short_id).first
        short_id = [prefix, rand(rnd_num)].join
        try_counter = try_counter + 1
        break if try_counter > (rnd_num/10)
      end

      # set short_id 
      self.short_id = short_id
    end

    def build_slugs
      unless self.title.blank?
        _slug = slug.blank? ? title : slug
        _slug = title if title_changed?
        _slug = slug  if slug_changed? && !slug.blank?

        self.slug        = _slug.to_s.to_slug_param
        self.friendly_id = [self.short_id, self.slug].join TheFriendlyId::SEPARATOR
      end
    end

  end

  module ClassMethods
    def friendly_where id
      if TheFriendlyId.int?(id)
        where(id: id)
      elsif id.is_a? Array
        where(slug: id)
      elsif TheFriendlyId.friendly?(id)
        where(friendly_id: id)
      elsif TheFriendlyId.short?(id)
        where(short_id: id)
      else
        where(slug: id)
      end
    end

    def friendly_first id
      friendly_where(id).first
    end
  end
end