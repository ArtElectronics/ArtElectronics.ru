class SearchController < ApplicationController
  before_action :define_hub_ids

  def index
    @squery   = params[:squery].to_s.strip
    to_search = Riddle::Query.escape @squery

    @pubs = if @hub_ids.blank?
      ThinkingSphinx.search(to_search, classes: [Post, Blog], sql: { include: :hub }).pagination(params)
    else
      ThinkingSphinx.search(to_search, classes: [Post, Blog], sql: { include: :hub }, with: { hub_id: @hub_ids }).pagination(params)
    end

    @search_results_size  = @pubs.size
    @search_results_count = @pubs.count

    render 'publications/index'
  end

  private

  def define_hub_ids
    @hub_ids  = []
    @in_blogs = params[:sb]
    @in_posts = params[:sp]

    if @in_blogs && blog_hub = Hub.with_slug(:blogs)
      @hub_ids << blog_hub.self_and_descendants.select(:id).map(&:id).uniq
    end

    if @in_posts && post_hub = Hub.with_slug(:posts)
      @hub_ids << post_hub.self_and_descendants.select(:id).map(&:id).uniq
    end
  end

end
