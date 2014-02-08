class UsersController < ApplicationController
  before_action :user_require,  only: [:cabinet]
  before_action :role_required, only: [:cabinet]

  def index
    @users = User.includes(:role).order("role_id ASC").page(params[:page])
  end

  def show
    @user = User.where(login: params[:id]).first
  end

  def new
    @user = User.new
  end

  # secured
  def cabinet; end
end
