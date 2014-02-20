class HubsController < ApplicationController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode
  
  before_action :set_hub_and_user, only: %w[show edit update destroy]

  before_action :user_require,   only: %w[new create edit update destroy]
  before_action :role_required,  only: %w[new create edit update destroy]
  before_action :owner_required, only: %w[edit update destroy]

  def new
    @hub = Hub.new
    set_selector_hubs
  end

  def create
    @hub = current_user.hubs.new(hub_params)

    if @hub.save
      redirect_to url_for([:edit, @hub.user, @hub]), notice: t("hubs.created")
    else
      render template: :new
    end
  end

  def edit
    set_selector_hubs
  end

  def update
    if @hub.update(hub_params)
      @hub.send "to_#{@hub_state}" if @hub_state
      redirect_to url_for([:edit, @hub.user, @hub]), notice: t("hubs.updated")
    else
      set_selector_hubs
      @hub.update_attachment_fields(:main_image)
    end
  end  

  def show
    @hub  = Hub.friendly_first(params[:id])
    @hubs = Hub.main_articles_hubs
    @sub_hubs = @hub.children

    @root_hub = @hub.root_hub
    #taichiman: for post index order like in old AE
    # @posts    = @hub.pubs.published_set.pagination(params)

    if @hubs.include? @hub
      #taichiman
      # @posts = Post.where(hub_id: @sub_hubs.map(&:id)).order(created_at: :desc).published_set.pagination(params)
      @sub_hubs.empty? ? child_hubs_id = @hub.id : child_hubs_id = @sub_hubs.map(&:id)      
      @posts = Post.where(hub_id: child_hubs_id).order(created_at: :desc).published_set.pagination(params)
    else  
      @posts    = @hub.pubs.order(created_at: :desc).published_set.pagination(params)
    end

    render template: 'posts/index'
  end

  def system_section
    @hub      = Hub.friendly_first(params[:id])
    @root_hub = @hub
    @sub_hubs = @hub.children

    @posts = @hub.self_and_children_pubs(@sub_hubs)
                 .published_set
                 .pagination(params)

    render template: 'posts/index'
  end
  
  # Admin area
  def manage
    @hubs = @user.hubs.roots.for_manage_rset.pagination(params)
  end

  private

  def set_selector_hubs
    @selector_hubs = current_user.available_hubs(@hub)
  end

  def set_hub_and_user
    @hub  = Hub.for_manage.friendly_first(params[:id])
    @user = @hub.user

    # TheRole
    @owner_check_object = @hub
  end

  def hub_params
    # TODO: user_id for create
    # TODO: user_id for update only for moderator|admin
    @hub_state = params[:hub].try(:[], :state)
    params.require(:hub).permit(
      :user_id,
      :hub_id,
      :slug,
      :main_image,
      :pubs_type,
      :author, :keywords, :description, :copyright,
      :title,
      :optgroup,
      :raw_intro,
      :raw_content
    )
  end
end