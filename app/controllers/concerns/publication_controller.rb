module PublicationController
  extend ActiveSupport::Concern

  included do
    before_action :set_klass
    before_action :set_post_and_user,   only: %w[show edit update destroy]
    before_action :set_audit,           only: %w[create show update edit destroy]

    before_action :user_require,   only: %w[new create edit update destroy]
    before_action :role_required,  only: %w[new create edit update destroy]
    before_action :owner_required, only: %w[edit update destroy]

    include TheSortableTreeController::ReversedRebuild

    def index
      # TODO: posts from hidden hubs should not be visible
      user   = User.where(login: user_id).first || @root
      @posts = user.send(controller_name).for_manage_rset.pagination(params)

      render 'posts/index'
    end

    def show
      @hub      = @post.hub
      @root_hub = @post.root_hub
      @comments = @post.comments.for_manage_set      
      
      @hubs = Hub.main_articles_hubs
      Post.increment_counter( :show_count, @post.id ) if @post.published?

      render 'posts/show'
    end

    def tag
      @tag   = params[:tag]
      @posts = Post.tagged_with(@tag).published.fresh.pagination(params)
      render 'posts/index'
    end

    # PROTECTED
    def manage
      @posts = @user.send(controller_name).for_manage_rset.pagination(params)
      render 'posts/manage'
    end

    def new
      @post = @klass.new
      set_selector_hubs
      render 'posts/new'
    end

    def create
      @post = current_user.send(controller_name).new(post_params)

      if @post.save
        redirect_to url_for([:edit, @post]), notice: t("pubs.created")
      else
        set_selector_hubs
        render 'posts/new'
      end
    end

    def edit
      set_selector_hubs
      render 'posts/edit'
    end

    def update
      if @post.update(post_params)
        @post.send "to_#{@post_state}" if @post_state
        redirect_to url_for([:edit, @post]), notice: t("pubs.updated")
      else
        @post.update_attachment_fields(:main_image)
        render 'posts/edit'
      end
    end

    def set_audit
      @audit = Audit.new.init(self, @post)
    end

    def destroy
      @post.destroy
      redirect_back_or posts_url
    end

    private

    def set_selector_hubs
      @selector_hubs = current_user.available_hubs(@post)
    end

    def set_klass
      @klass      = controller_name.classify.constantize
      @klass_name = controller_name.singularize.to_sym
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post_and_user
      @post = @klass.for_manage.with_users.friendly_first(params[:id])
      @user = @post.user

      # TheRole
      @owner_check_object = @post
    end

    def user_id
      params[:user] || params[:user_id]
    end

    def post_params
      # TODO: user_id for create
      # TODO: user_id for update only for moderator|admin
      @post_state = params[@klass_name].try(:[], :state)
      params.require(@klass_name).permit(
        :user_id,
        :hub_id,
        :slug,
        :main_image,
        :pub_type,
        :author, :keywords, :description, :copyright,
        :title,
        :raw_intro,
        :raw_content,
        :name_list, :word_list, :title_list
      )
    end
  end
end