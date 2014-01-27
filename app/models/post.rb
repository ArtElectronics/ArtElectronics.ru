class Post < ActiveRecord::Base
  acts_as_taggable_on :names, :words, :titles

  include BasePublication

  class << self
    def create_post!
      post = Post.new(
        friendly_id: 1,
        title: "test title",
        slug: "test slug",
        user: User.find( 1 )
      )
      post.save!
      post
    end
  end

end