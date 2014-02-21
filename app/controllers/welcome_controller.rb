class WelcomeController < ApplicationController
  def index
    per_count = 7
    @hubs  = Hub.main_articles_hubs
    @posts = Post.published_rset.pagination(params)
  end

  # Legacy urls
  def legacy_post
    c_slug = params[:c_slug]
    s_slug = params[:s_slug]
    id     = params[:id]

    if post = Post.where(legacy_url: "#{c_slug}/#{s_slug}/#{id}").first
      redirect_to post_url(post.friendly_id), status: :moved_permanently
    end
  end
  
  def legacy_hub
    c_slug = params[:c_slug]
    s_slug = params[:s_slug]

    if hub = Hub.where(legacy_url: "#{c_slug}/#{s_slug}").first
      redirect_to hub_url(hub.friendly_id), status: :moved_permanently
    end
  end

  def legacy_blog
    blog_hub = Hub.find_by(slug: 'system-blogs')
    id = params[:id]

    if blog = Post.where( hub_id: blog_hub.id, legacy_url: id ).published.first
      redirect_to post_url(blog.friendly_id), status: :moved_permanently
    end
  end
end
