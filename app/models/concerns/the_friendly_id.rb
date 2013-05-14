# friendly_id h11149+menu-10-u-5  # uniq
# short_id    h11149              # uniq
# id          50                  # uniq

module TheFriendlyId
  extend ActiveSupport::Concern

  SEPARATOR = "+"

  def self.int? str
    str.to_i.to_s == str
  end

  def self.friendly? str
    Regexp.new("\\#{TheFriendlyId::SEPARATOR}") =~ str
  end

  def TheFriendlyId.short? str
    str =~ /^[A-Z]+[0-9]+$/mix
  end

  included do
    def to_param; self.friendly_id end

    validates_presence_of :short_id, :friendly_id

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
        recipe:  :rc,
        article: :a
      }[klass]

      prefix  ||= 'x'
      rnd_num   = 9999

      # build short_id
      short_id = [prefix, rand(rnd_num)].join

      # rebuild if find identically short_id
      while self.class.where(short_id: short_id).first
        short_id = [prefix, rand(rnd_num)].join
      end

      # set short_id 
      self.short_id = short_id
    end

    def build_slugs
      unless self.title.blank?
        text_name        = Russian::translit(self.title.to_s).gsub('_','-').parameterize
        self.friendly_id = [self.short_id, text_name].join TheFriendlyId::SEPARATOR
      end
    end

  end

  module ClassMethods
    def friendly_where id
      if TheFriendlyId.int?(id)
        where(id: id)
      elsif TheFriendlyId.friendly?(id)
        where(friendly_id: id)
      elsif TheFriendlyId.short?(id)
        where(short_id: id)
      else
        where(slug: id)
      end
    end
  end
end