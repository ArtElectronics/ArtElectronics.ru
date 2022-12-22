class UsersController < ApplicationController
  # STATUS: DONE

  layout 'bootstrap_default', only: %w[ index cabinet show edit update change_email ]

  before_action :set_user, only: %w[
    show edit update
    avatar_crop avatar_delete
    change_password change_email
  ]

  before_action :user_require,   except: %w[ index show new ]
  before_action :role_required,  except: %w[ index show new ]
  before_action :owner_required, except: %w[ index show new cabinet ]

  # Public actions

  def index
    @users = User.includes(:role).order("role_id ASC").simple_sort(params).pagination(params)
  end

  def cabinet; end

  def new; @user = User.new ; end

  # Restricted actions

  def show; end

  def edit
    @authors = Author.pluck(:name, :id)
  end

  def update
    if @user.update(user_params)
      @user.author = Author.find(params[:user][:author])
      redirect_to url_for([:edit, @user]), notice: "Изменения сохранены"
    else
      @user.reload
      render 'users/edit'
    end
  end

  def avatar_crop
    path = @user.avatar_crop(params)
    render json: { ids: { avatar_medium: path } }
  end

  def avatar_delete
    @user.avatar = nil
    @user.save
    redirect_back notice: "Изображение удалено"
  end

  def change_password
    @user.send_reset_password_instructions
    redirect_to url_for([:edit, @user]), notice: "В течение нескольких минут вы получите письмо с инструкциями по смене пароле"
  end

  def change_email
    if @user.update(user_params)
      redirect_to url_for([:edit, @user]), notice: "В течение нескольких минут вы получите письмо с инструкциями по подтверждению вашего нового Email."
    else
      @user.reload
      render 'users/edit'
    end
  end

  private

  def set_user
    @user = User.where(login: user_id).first
    @owner_check_object = @user
  end

  def user_id
    params[:id] || params[:user_id]
  end

  def user_params
    params.require(:user).permit(
      :avatar, :login, :username, :email, :raw_about,
      :vk_addr, :tw_addr, :fb_addr, :ig_addr, :pt_addr, :gp_addr
    )
  end
end
