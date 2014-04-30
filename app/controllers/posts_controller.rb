class PostsController < ApplicationController
  include PublicationController

  before_action :prepare_all_tags, only: %w[ new edit ]

  def prepare_all_tags
    @tags = {}
    AppConfig.tag_contexts.each do | c |
      @tags[ c ] = tags( c.pluralize )
    end
  end

  private

  def tags context
    ActsAsTaggableOn::Tagging.where(context: context).
      joins(:tag).
      pluck('DISTINCT tags.name')
  end
end
