namespace :main_images do
  # rake main_images:resize
  # task resize: :environment do
  #   posts_count = Post.count
  #   Post.all.each_with_index do |post, index|
  #     src     = post.main_image.path :original
  #     base    = post.main_image.path :base
  #     preview = post.main_image.path :preview

  #     post.manipulate({ src: src, dest: base }) do |image, opts|
  #       to_rect image, 270, 210
  #     end

  #     post.manipulate({ src: src, dest: preview }) do |image, opts|
  #       to_square image, 100
  #     end

  #     puts "#{ index }/#{ posts_count }"
  #   end
  # end

  # rake main_images:resize100
  task resize100: :environment do
    posts_count = Blog.count
    Blog.all.each_with_index do |post, index|
      src     = post.main_image.path :original
      base    = post.main_image.path :base

      post.manipulate({ src: src, dest: base }) do |image, opts|
        to_rect image, 220, 220
      end

      puts "#{ index }/#{ posts_count }"
    end
  end
end
