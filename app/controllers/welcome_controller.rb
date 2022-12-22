class WelcomeController < ApplicationController
  def page_404
    render status: 404
  end

  def islands
    @recent_posts = Post.where(hub: Hub.main_articles_hubs).published.moderated.recent(:created_at).limit(7)
    @recent_blogs = Hub.with_slug(:blogs).blogs.published.moderated.recent(:created_at).limit(5)
    @future_posts = Hub.with_slug(:future_future).posts.published_rset.moderated.recent(:created_at).limit(3)
  end

  def index
    @hubs    = Hub.main_articles_hubs
    hubs_ids = @hubs.map(&:id)
    @posts   = Post.where(hub_id: hubs_ids).published_rset.pagination(params)
  end

  # RSS FEEDS
  def rss
    @posts = Post.where(hub: Hub.main_articles_hubs).published.recent(:created_at).limit(10)
  end

  def feedly
    @posts  = Post.where(hub: Hub.main_articles_hubs).published.recent(:created_at).limit(30)
    @posts |= Hub.with_slug(:blogs).blogs.published.recent(:created_at).limit(30)
  end

  def yandex
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_yandex_news
    @posts |= Hub.with_slug(:blogs).blogs.for_yandex_news
  end

  def flipboard_culture
    @feed_name = 'Культура'
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_flipboard_culture
    @posts |= Hub.with_slug(:blogs).blogs.for_flipboard_culture
    render 'welcome/flipboard'
  end

  def flipboard_tech
    @feed_name = 'Технологии'
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_flipboard_tech
    @posts |= Hub.with_slug(:blogs).blogs.for_flipboard_tech
    render 'welcome/flipboard'
  end

  def surfingbird
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_surfingbird
    @posts |= Hub.with_slug(:blogs).blogs.for_surfingbird
  end

  def novoteka
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_novoteka
    @posts |= Hub.with_slug(:blogs).blogs.for_novoteka
  end

  def rambler
    @posts  = Post.where(hub: Hub.main_articles_hubs).for_yandex_news
    @posts |= Hub.with_slug(:blogs).blogs.for_yandex_news
  end

  def rss_full
    @posts = Post.where(hub: Hub.main_articles_hubs).published.recent(:created_at).limit(10)
  end

  def telegraf_full
    @posts = Post.where(hub: Hub.with_slug('telegraf-telegraf')).published.recent(:created_at).limit(10)
  end

  def sitemap
    @posts  = Post.where(hub: Hub.main_articles_hubs).published.recent(:created_at)
    @posts |= Hub.with_slug(:blogs).blogs.published.recent(:created_at)
  end

  # Legacy urls
  def legacy_search
    if q = params[:q]
      return redirect_to qsearch_path(q), status: :moved_permanently
    end

    redirect_to root_path, status: 422
  end

  def legacy_articles
    if tag = params[:tag]
      return redirect_to tag_path(tag), status: :moved_permanently
    end

    redirect_to posts_path, status: :moved_permanently
  end

  def legacy_post
    c_slug = params[:c_slug]
    s_slug = params[:s_slug]
    id     = params[:id]

    if post = Post.where(legacy_url: "#{ c_slug }/#{ s_slug }/#{ id }").first
      return redirect_to post_url(post), status: :moved_permanently
    end

    redirect_to root_path, flash: { error: "Страница не найдена" }
  end

  def legacy_hub
    c_slug = params[:c_slug]
    s_slug = params[:s_slug]

    if hub = Hub.where(legacy_url: "#{ c_slug }/#{ s_slug }").first
      return redirect_to hub_url(hub), status: :moved_permanently
    end

    redirect_to root_path, flash: { error: "Страница не найдена" }
  end

  def legacy_blog
    id = params[:id]
    blog   = Hub.find_by(slug: :blogs).blogs.where(legacy_url: id).published.first
    blog ||= Hub.find_by(slug: :blogs).blogs.where(id: id).published.first

    return redirect_to blog_url(blog), status: :moved_permanently if blog
    redirect_to root_path, flash: { error: "Страница не найдена" }
  end
end
