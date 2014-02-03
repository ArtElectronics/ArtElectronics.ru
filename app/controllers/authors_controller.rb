class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  before_action :user_require
  before_action :role_required

  def index
    @authors = Author.all.page params[:page]
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to url_for([:edit, @author]), notice: t('authors.created')
    else
      render action: 'new' 
    end
  end

  def update
    if @author.update(author_params)
      redirect_to url_for([:edit, @author]), notice: t('authors.updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_url
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :description, :short_description)
    end
end
