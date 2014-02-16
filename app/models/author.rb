class Author < ActiveRecord::Base
  def to_param; name; end

  # relations
  has_many   :authorships
  has_many   :posts, through: :authorships
  belongs_to :user

  # validation
  validates :name,        presence: true
  validates :description, presence: true
end
