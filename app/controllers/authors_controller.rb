class AuthorsController < ApplicationController
  layout 'bootstrap_default', except: %w[ index show by_letter ]

  before_action :set_author, only: %w[ show edit update destroy ]

  before_action :user_require,  except: %w[ index show by_letter ]
  before_action :role_required, except: %w[ index show by_letter ]

  def index
    @authors = Author.all.page params[:page]
  end

  def show; end

  def by_letter
    @authors = Author.by_letter(params[:letter]).page params[:page]
    render template: 'authors/index'
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to url_for(@author), notice: t('authors.created')
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

  def manage
    @authors = Author.all.page params[:page]
  end

  private
    def set_author
      @author = Author.where(id: params[:id]).first || Author.where(name: params[:id]).first
    end

    def author_params
      params.require(:author).permit(
        :name,
        :avatar,

        :user_id,
        :first_letter,

        :description,
        :short_description
      )
    end
end
