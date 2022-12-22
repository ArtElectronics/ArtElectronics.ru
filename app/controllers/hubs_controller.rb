class HubsController < ApplicationController
  include PublicationController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode

  layout 'bootstrap_default', only: %w[ new edit manage ]
  before_action :set_hub

  def new
    @hub = Hub.new
  end

  def create
    @hub = current_user.hubs.new(hub_params)

    if @hub.save
      redirect_to url_for([:edit, @hub.user, @hub]), notice: t("hubs.created")
    else
      render template: :new
    end
  end

  def edit; end

  def update
    if @hub.update(hub_params)
      @hub.send "to_#{@hub_state}" if @hub_state
      redirect_to url_for([:edit, @hub.user, @hub]), notice: t("hubs.updated")
    else
      @hub.update_attachment_fields(:main_image)
    end
  end

  def show
    @hubs = Hub.main_articles_hubs

    @sub_hubs = @hub.children
    @root_hub = @hub.root_hub

    @pubs = @hub.self_and_children_pubs(@sub_hubs)
              .published.moderated
              .recent(:created_at)
              .pagination(params)

    render template: 'publications/index'
  end

  def system_section
    set_pub_and_user
    return redirect_to(url_for(@pub), status: 301) unless performed?
  end

  # Admin area
  def manage
    @hubs = @user.hubs.roots.for_manage_rset.pagination(params)
  end

  private

  def set_hub
    @hub = @pub
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
