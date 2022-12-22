module PublicationController
  extend ActiveSupport::Concern

  included do
    include MainImageCtrl
    include TheSortableTreeController::ReversedRebuild

    layout 'bootstrap_default', only: %w[ my new edit manage create update ]

    before_action :set_klass

    before_action :set_pub_and_user, only: (%w[ show print edit update destroy ] + MainImageCtrl::ACTIONS)
    before_action :set_audit,        only:  %w[ show print edit update destroy ]

    before_action :user_require,   except: %w[ index show ]
    before_action :role_required,  except: %w[ index show ]
    before_action :owner_required, except: %w[ index create show my manage new expand_node rebuild ]

    before_action :prepare_all_tags, except: %w[ index new show my manage new ]
  end

  # Public actions

  def index
    @pubs = (User.where(login: user_id).first || @root)
      .send(controller_name)
      .published.recent(:created_at)
      .pagination(params)
  end

  def show
    @hub      = @pub.hub
    @root_hub = @pub.root_hub
    @comments = @pub.comments.for_manage_set

    @hubs = Hub.main_articles_hubs
    @klass.increment_counter(:show_count, @pub.id) if @pub.published?
  end

  def print
    render layout: false, template: 'publications/print'
  end

  # def tag
  #   @tag  = params[:tag]
  #   @pubs = @klass.tagged_with(@tag).published.recent(:id).pagination(params)
  #   render 'publications/index'
  # end

  # Restricted actions

  def my
    @pubs = @user.send(controller_name).recent(:id).simple_sort(params).pagination(params)
    render 'publications/manage'
  end

  def manage
    @pubs = if current_user.moderator?(@klass_name.to_s.tableize)
      @klass.recent(:id).simple_sort(params).pagination(params)
    else
      @user.send(controller_name).recent(:id).simple_sort(params).pagination(params)
    end

    render 'publications/manage'
  end

  def new
    @pub = @klass.new
    render 'publications/new'
  end

  def create
    @pub = current_user.send(controller_name).new(post_params)
    @pub.content_processing_for(current_user)

    if @pub.save
      SystemMessage.create_publication(current_user, @pub)
      redirect_to url_for([:edit, @pub]), notice: t("pubs.created")
    else
      render 'publications/new'
    end
  end

  def edit
    render 'publications/edit'
  end

  def update
    @pub.assign_attributes(post_params)
    @pub.content_processing_for(current_user)
    @pub.update_moderation_info(current_user)

    if @pub.save
      redirect_to url_for([:edit, @pub]), notice: t("pubs.updated")
    else
      @pub.update_attachment_fields(:main_image)
      render 'publications/edit'
    end
  end

  def destroy
    @pub.destroy
    redirect_back_or root_path
  end

  private

  def set_audit
    @audit = Audit.new.init(self, @pub) if Audit.table_exists?
  end

  def set_klass
    @klass      = controller_name.classify.constantize
    @klass_name = controller_name.singularize.to_sym
  end

  def pub_id
    params[:id]           ||
    params[:post_id]      ||
    params[:blog_id]      ||
    params[:page_id]
  end

  def set_pub_and_user
    @pub = @klass.publication_access(current_user).with_users.friendly_first(pub_id)
    return page_404 unless @pub

    @user = @pub.user
    @owner_check_object = @pub
  end

  def user_id
    params[:user] || params[:user_id]
  end

  def post_params
    # TODO: user_id for create
    # TODO: user_id for update only for moderator|admin
    params.require(@klass_name).permit(
      :slug,
      :hub_id,
      :main_image,

      :title,
      :raw_intro,
      :raw_content,
      :state,

      :user_id,
      :pub_type,

      :author, :keywords, :description, :copyright,
      :name_list, :word_list, :title_list,
      :comments_switcher,
      :moderation_state,
      :moderator_note,

      :yandex_news,
      :flipboard_culture,
      :flipboard_tech,
      :surfingbird,
      :novoteka
    )
  end

  def prepare_all_tags
    @tags = {}
    AppConfig.tag_contexts.each do |context|
      @tags[context] = tags_in_context(context.pluralize)
    end
  end

  def tags_in_context context
    ActsAsTaggableOn::Tagging.where(context: context).
      joins(:tag).pluck('DISTINCT tags.name')
  end
end
