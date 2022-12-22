# required by config/initializers/acts_as_taggable_on.rb
# restart web server after change
class ActsAsTaggableOn::Tagging
  include TheSimpleSort::Base
  include ThePagination::Base

  paginates_per 15

  belongs_to :published_pub,
    ->(o) { where(state: :published) },
    polymorphic:  true,
    foreign_key:  :taggable_id,
    foreign_type: :taggable_type
end
