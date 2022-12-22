TheBanners.configure do |config|
  config.images_path = ':rails_root/public/uploads/:class/:attachment/:style/:filename'
  config.images_url  = '/uploads/:class/:attachment/:style/:filename'
end
