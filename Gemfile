source 'https://rubygems.org'
# source 'http://gems.github.com'
# Delete all gems: gem list | cut -d' ' -f1 | xargs gem uninstall -aIx
# for i in `gem list --no-versions`; do gem uninstall -aIx $i; done

gem 'rails', '4.2.11.1' # '4.1.5'
gem 'puma', '3.7.1'
gem 'json', '2.0.0' # 1.8.3

gem 'colorize', '0.8.1'
gem 'newrelic_rpm', '3.18.1.330'
gem 'exception_notification', '4.0.1'

# Datebase
gem 'mysql2', '0.4.10' # '0.3.20'


# App level
gem 'devise', '3.4.1' # '3.3.0'
# github: 'plataformatec/devise',
# branch: 'lm-rails-4-2'

gem 'omniauth-twitter', '1.0.1'
gem 'omniauth-facebook', '2.0.0'
gem 'omniauth-vkontakte', '1.3.2'
gem "omniauth-google-oauth2", '0.2.5'

gem 'config', '1.3.0'
gem 'whenever', '0.9.7'

gem 'sidekiq', '4.2.1'
gem 'sidekiq-limit_fetch', '3.3.0'

gem 'redis-namespace', '1.5.2'
gem 'sinatra', '1.0', require: nil
# views
gem 'truncato', '0.7.8'
gem 'jquery-rails', '3.1.1'
gem 'jquery-ui-rails', '5.0.0'
gem 'jbuilder', '1.0.2'

gem 'haml', '4.0.5'
gem 'slim', '2.0.3'
gem 'role_block_haml', '0.2.4'

gem 'kaminari', '0.16.1'
gem 'minitest', '5.10.1'

gem 'sass', '~> 3.4.1'
gem 'font-awesome-sass', '4.1.0'
gem 'sass-rails', '5.0.0.beta1'

gem 'bootstrap-sass',
  git: 'https://github.com/twbs/bootstrap-sass',
  branch: "54317e5c02a4915e7a5def3a3e94cc2738a51ed3"

gem 'compass-rails', '2.0.0'
  # git: 'https://github.com/Compass/compass-rails'

gem "autoprefixer-rails", '5.2.1'
# ? /removed/ gem 'actionview-encoded_mail_to', '1.0.4'

# Search
gem 'thinking-sphinx', '5.4.0'

# Models
gem 'gibbon', '1.1.5'
gem 'sanitize', '3.0.0'
gem 'rails_autolink', '1.1.6'
gem 'state_machine', '1.2.0'
gem 'RedCloth', '4.2.9', require: 'redcloth'
gem 'acts-as-taggable-on', "3.4"

gem 'awesome_nested_set', '3.0.0'
  # git: "https://github.com/collectiveidea/awesome_nested_set",
  # branch: "master"

# Images and files
gem 'mini_magick', '3.8.0'
gem 'paperclip', '4.2.0'

gem 'the_banners',
  # path: '../TheBanners'
  git: 'https://github.com/TheProfitCMS/TheBanners',
  branch: 'master'

gem 'the_string_addon',
  # path: '../the_string_addon'
  git: 'https://github.com/TheProfitCMS/the_string_addon',
  branch: 'master'

gem 'the_image',
  # path: '../the_image'
  git: 'https://github.com/TheProfitCMS/the_image',
  branch: 'master'

gem 'the_crop',
  # path: '../the_crop'
  git: 'https://github.com/TheProfitCMS/the_crop',
  branch: 'master'

gem 'the_storages',
  # path: '../the_storages'
  git: 'https://github.com/TheProfitCMS/the_storages',
  branch: 'ff7df0134e4ef227fe8'

# Open Cook components
gem 'to_slug_param',
  #, path: '../the_string_to_slug' #, '~> 0.0.6'
  git: 'https://github.com/TheOpenCMS/to_slug_param',
  branch: 'master'

gem 'the_friendly_id',
  # path: '../the_friendly_id'
  git: 'https://github.com/TheProfitCMS/the_friendly_id',
  branch: 'master'

gem "the_notification",
  # path: '../the_notification'
  git: 'https://github.com/TheProfitCMS/the_notification',
  branch: 'master'

gem 'the_simple_sort',
  # path: '../the_simple_sort'
  git: 'https://github.com/TheProfitCMS/the_simple_sort',
  branch: 'master'

gem 'the_pagination',
  # path: '../the_pagination'
  git: 'https://github.com/TheProfitCMS/the_pagination',
  branch: 'master'

gem 'the_audit',
  # path: '../the_audit'
  git: 'https://github.com/TheProfitCMS/the_audit',
  branch: 'master'

gem 'the_encrypted_string',
  # path: '../the_encrypted_string'
  git: 'https://github.com/TheProfitCMS/the_encrypted_string',
  branch: 'master'

gem 'the_sortable_tree', '2.5.0'
  # path: '../the_sortable_tree'
  # github: 'the-teacher/the_sortable_tree',
  # branch: 'master'

gem 'the_role',
  # path: '../the_role'
  git: 'https://github.com/the-teacher/the_role',
  branch: '62b5e403b3f2d102'

gem 'the_role_management_panel',
  # path: '../the_role_bootstrap3_ui'
  git: 'https://github.com/TheRole/the_role_management_panel',
  branch: 'master'

gem "the_comments",
  # path: '../the_comments'
  git: 'https://github.com/the-trash/the_comments',
  branch: 'master'

group :development, :test do
  # gem 'thin'
  # gem 'faker'
  # gem 'seedbank', github: 'james2m/seedbank'

  gem 'rspec', '3.0.0'
  gem 'rspec-core', '3.0.4'
  gem 'rspec-rails', '3.0.2'
  gem 'rspec-mocks', '3.0.4'
  gem 'rspec-expectations', '3.0.4'

  gem "better_errors", "2.0.0"
  gem "binding_of_caller", "0.7.2"
end

group :development do
  gem 'pry', "0.10.1"
  gem 'pry-byebug', '1.3.3'
  gem 'quiet_assets', '1.0.3'
  gem 'foreman', '0.83.0'

  # gem 'asset-image-opt'
  # brew install https://raw.github.com/cbguder/homebrew/53ea33bab5372ea74117ace8c44aa7ea988e93c2/Library/Formula/pngout.rb
end

group :assets do
  gem 'coffee-rails', '4.0.1'
  gem 'uglifier', '2.5.3'
  # gem 'sprockets', '2.12.1'
  # gem 'sprockets-rails'
end

group :test do
  # gem 'capybara'
  gem 'factory_girl', '4.4.0'
  gem 'database_cleaner', '1.3.0'
end
