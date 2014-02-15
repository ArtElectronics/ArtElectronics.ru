class Post < ActiveRecord::Base
  acts_as_taggable_on :names, :words, :titles

  include BasePublication

  # relations
  has_many :authorships
  has_many :authors, through: :authorships
end
