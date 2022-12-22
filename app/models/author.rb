class Author < ActiveRecord::Base
  include HasMetaData
  def to_param; name; end

  has_attached_file :avatar,
                    styles: { :small => "90x90#", :big => "150x150#" },
                    default_url: "/default_images/author/avatar/:style/missing.jpg",
                    path: ":rails_root/public/uploads/storages/author/:id/avatar/:style/:id.:extension",
                    url: "/uploads/storages/author/:id/avatar/:style/:id.:extension"

    # :url => "/system/:class/:style/:id.:extension",
    # :path => "#{RAILS_ROOT}/public/system/:class/:style/:id.:extension"
  do_not_validate_attachment_file_type :avatar

  before_validation :define_first_letter

  # relations
  has_many   :authorships
  has_many   :posts, through: :authorships
  belongs_to :user

  # validation
  validates :name,        presence: true
  validates :description, presence: true

  scope :by_letter, ->(letter) { where("first_letter LIKE ?", "#{ letter }%") }

  def self.alphabet
    en, ru = Author.pluck(:first_letter).map{|item| item.mb_chars.downcase.to_s }.uniq.sort.map(&:ord).inject([ [], [] ]) do |res, item|
      res.first.push(item) if item < 1000
      res.last.push(item)  if item >= 1000
      res
    end

    [ en.uniq.map(&:chr), ru.uniq.map(&:chr) ]
  end

  private

  def define_first_letter
    return true if self.first_letter.present?
    self.first_letter = self.name.split(' ').last.first.mb_chars.upcase.to_s
  end
end
