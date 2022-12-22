class PostsController < ApplicationController
  include PublicationController

  def index
    super
    render template: 'publications/index'
  end

  def show
    super
    render template: 'publications/show'
  end

  def edit
    @authors = Author.pluck(:name)

    super
  end

  def update
    authors = Author.where(name: params[:post][:author_list].split(',').map { |name| name.strip } )
    @pub.authors = Array.wrap(authors)

    super
  end

  private

  def set_post_and_user
    @post = @klass.publication_access(current_user).with_users.friendly_first(params[:id])

    # Hook for fix lagacy urls
    if @post.blank?
      blog = Blog.publication_access(current_user).with_users.friendly_first(params[:id])
      return redirect_to(blog, status: 301) if blog
    end

    return page_404 unless @post

    @user = @post.user
    @owner_check_object = @post
  end
end
