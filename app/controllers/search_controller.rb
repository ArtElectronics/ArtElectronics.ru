class SearchController < ApplicationController
  before_action :define_hub_ids

  def index
    @squery = params[:squery].to_s.strip
    to_search = Riddle::Query.escape @squery
    
    @search_results = if @hub_ids.blank?
      Post.search(to_search).pagination(params)
    else
      Post.search(to_search, with: { hub_id: @hub_ids } ).pagination(params)
    end

    @search_results_size  = @search_results.size
    @search_results_count = @search_results.count
  end

  private

  def define_hub_ids
    @hub_ids  = []
    @in_blogs = params[:sb]
    @in_posts = params[:sp]
    
    if @in_blogs && blog_hub = Hub.with_slug(:system_blogs)
        @hub_ids << blog_hub.self_and_descendants.select(:id).map(&:id).uniq
      end
    end

    if @in_posts && post_hub = Hub.with_slug(:system_article_categories)
        @hub_ids << post_hub.self_and_descendants.select(:id).map(&:id).uniq
      end
    end
  end
end