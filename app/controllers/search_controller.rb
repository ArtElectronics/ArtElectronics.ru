class SearchController < ApplicationController
  def index
    @search_result = Post.search(params[:q]).pagination(params)
  end
end