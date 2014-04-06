class ThinkingSphinx::Search
  def pagination params
    page(params[:page]).per(params[:per_page])
  end
end