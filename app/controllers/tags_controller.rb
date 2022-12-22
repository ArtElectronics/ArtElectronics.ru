class TagsController < ApplicationController
  def show
    @tag = params[:tag]

    tag_name = ActsAsTaggableOn::Tag.send(:comparable_name, @tag)
    tag = ActsAsTaggableOn::Tag.where(name: tag_name).first

    @taggings = if tag
      tag.taggings.includes(:published_pub)
      .recent(:created_at).pagination(params)
    else
      ActsAsTaggableOn::Tag.none
    end
  end
end
