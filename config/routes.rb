require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'qwerty'
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/async/tasks'

  # Base
  root to: 'welcome#islands'
  get '/index' => 'welcome#index'
  get '/page_404' => 'welcome#page_404', as: :page_404

  get '/articles' => 'welcome#legacy_articles'
  get '/search'   => 'welcome#legacy_search'

  get '/new',  to: redirect('/', status: 301) # 410
  get '/news', to: redirect('/', status: 301)

  get '/authors_articles', to: redirect('/', status: 301)
  get '/blogs.rss', to: redirect('/rss.rss',  status: 301)
  get '/archive',   to: redirect('/archive_numbers', status: 301)
  get '/archives',  to: redirect('/archive_numbers', status: 301)
  get '/partners',  to: redirect('/pages/partners',  status: 301)

  get '/hubs/future', to: redirect('/hubs/future-future', status: 301)

  get '/materia',  to: redirect('http://artelectronics.ru/posts/myslyaschaya-materiya', status: 301)
  get '/materiya', to: redirect('http://artelectronics.ru/posts/myslyaschaya-materiya', status: 301)

  # XML feeds
  get '/feedly.rss'        => 'welcome#feedly',      defaults: { format: :rss }
  get '/novoteka.rss'      => 'welcome#novoteka',      defaults: { format: :rss }
  get '/yandex.rss'        => 'welcome#yandex',        defaults: { format: :rss }
  get '/rss.rss'           => 'welcome#rss',           defaults: { format: :rss }
  get '/rss_full.rss'      => 'welcome#rss_full',      defaults: { format: :rss }
  get '/telegraf_full.rss' => 'welcome#telegraf_full', defaults: { format: :rss }
  get '/rambler.rss'       => 'welcome#rambler',       defaults: { format: :rss }
  get '/surfingbird.rss'   => 'welcome#surfingbird',   defaults: { format: :rss }

  get '/flipboard_culture.rss' => 'welcome#flipboard_culture', defaults: { format: :rss }
  get '/flipboard_tech.rss'    => 'welcome#flipboard_tech',    defaults: { format: :rss }

  get '/sitemap.xml'       => 'welcome#sitemap',       defaults: { format: :xml }

  # Login system
  devise_for :users, path: '',
    :path_names => {
      sign_in:  'login',
      sign_up:  'signup',
      sign_out: 'logout'
    },
    :controllers => {
      :omniauth_callbacks => "omniauth_callbacks",
      :confirmations      => "confirmations",
      :registrations      => "registrations",
      :sessions           => "sessions",
      :passwords          => "passwords"
    }

  devise_scope :user do
    get '/account_should_be_activate' => 'registrations#account_should_be_activate'
  end

  # Personal
  get "cabinet" => "users#cabinet", as: :cabinet

  # Search
  match "search/:squery" => "search#index", via: %w[ get post ], as: :qsearch

  # Special Posts
  post '/tatlin_postcard' => 'special_posts#tatlin_postcard'

  %w[ authors archive_numbers ].each do |model|
    resources model do
      collection do
        get :manage
      end
    end
  end

  get '/authors/:id' => 'authors#show', constraints: {:id => /[^\/]+/}
  get "authors/by/:letter" => "authors#by_letter", as: :author_by_letter

  resources :meta_data

  TheAudit::Routes.mixin(self)
  TheBanners::Routes.mixin(self)

  # Subscribers
  post "subscribers/add" => "subscribers#add", as: :add_subscriber

  namespace :admin do
    TheRole::Routes.mixin(self)
  end

  # TheComments
  concern   :user_comments,  TheComments::UserRoutes.new
  concern   :admin_comments, TheComments::AdminRoutes.new
  resources :comments, concerns:  [:user_comments, :admin_comments]

  concern :sortable_tree do
    collection do
      get  :manage
      post :rebuild
    end
  end

  # legacy url
  get '/blogs/:id' => 'welcome#legacy_blog', constraints: { id: /\d{1,3}/ }

  # Direct routes
  %w{ hubs pages posts blogs }.each do |name|
    resources name, concerns: :sortable_tree do
      get :print

      member do
        patch  :main_image_crop_270x210
        patch  :main_image_crop_100x100
        patch  :main_image_rotate
        delete :main_image_delete
      end
    end
  end

  resources :hubs do
    post :expand_node, on: :collection
  end

  # Users
  resources :users, only: %w[ index show edit update ] do
    patch  :change_email
    patch  :change_password

    patch  :avatar_crop
    delete :avatar_delete

    %w[ hubs pages posts blogs ].each do |name|
      resources name, concerns: :sortable_tree do
        get :my, on: :collection
      end
    end
  end

  # tags
  # tags
  get "tag/:tag" => "tags#show", as: :tag

  # /users/:user_id/manage/posts
  get "manage/:pub_type" => 'posts#manage', as: :pubs_manage
  get "users/:user_id/manage/:pub_type" => 'posts#manage', as: :user_pubs_manage
  get "/:id" => 'hubs#system_section', as: :system_hub

  # Mailer
  get '/rails/mailers' => "rails/mailers#index"
  get '/rails/mailers/*path' => "rails/mailers#preview"

  # Legacy Urls
  get '/:c_slug/:s_slug/:id' => 'welcome#legacy_post'
  get '/:c_slug/:s_slug'     => 'welcome#legacy_hub'
end
