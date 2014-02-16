class Comment < ActiveRecord::Base
  include TheComments::Comment
  include CommonClassMethods

  def self.recent_five
    with_state(:published).where(commentable_state: :published).recent.limit(5)
  end
end
