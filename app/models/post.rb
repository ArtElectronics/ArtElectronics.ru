class Post < ActiveRecord::Base
  acts_as_taggable_on :names, :words, :titles
  include BasePublication
  include FutureTextMethods

  # relations
  has_many :authorships
  has_many :authors, through: :authorships

  def inline_author_tags
    authors.pluck(:name).join(', ')
  end
end
