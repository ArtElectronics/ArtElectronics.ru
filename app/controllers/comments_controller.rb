class CommentsController < ApplicationController
  layout 'bootstrap_default'

  # Define your restrict methods and use them like this:
  #
  # before_action :user_required,      except: [:index, :create]
  #
  # before_action :owner_required,     only: [:my, :incoming, :edit, :trash]
  # before_action :moderator_required, only: [:update, :to_published, :to_draft, :to_spam, :to_trash]

  include TheComments::Controller

  def create
    @comment = @commentable.comments.new comment_params

    if @comment.valid?
      @comment.save
      @comment.to_published if current_user
      return render layout: false, partial: comment_partial(:comment), locals: { tree: @comment }
    end

    render json: { errors: @comment.localized_errors }
  end

  # Public methods:
  #
  # [:index, :create]

  # Application side methods:
  # Overwrite following default methods if it's need
  # Following methods based on *current_user* helper method
  #
  # [:my, :incoming, :edit, :trash]

  # You must protect following methods
  # Only comments moderator (holder or admin) can invoke following actions
  #
  # [:update, :to_published, :to_draft, :to_spam, :to_trash]
end
