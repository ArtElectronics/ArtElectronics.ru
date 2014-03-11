# =================================
# How to move main_images data to new Engine?
# =================================
# Check or set MAIN_IMAGE_OLD_PATH, MAIN_IMAGE_BLOGS_OLD_PATH
# rake ae:main_image_start
# 
# Вручную надо перенести картинку со spoof именем '98.0' для блога 'Schizophrenia Taiwan 2.0' от 2013-11-28, путь: /public/system/blogs/original
# =================================

MAIN_IMAGE_POSTS_OLD_PATH=Rails.root+"public/system/articles/original/"
MAIN_IMAGE_BLOGS_OLD_PATH=Rails.root+"public/system/blogs/original/"

namespace :ae do
  desc "Drag main image to new base"
  task :main_image_start do
      %w[
        drag_main_image_posts_start
        drag_main_image_blogs_start
      ].each { |task| Rake::Task["ae:main_image:#{task}"].invoke}
  end

  namespace :main_image do
    desc "Перетаскиваем заглавные картинки для постов"
    task drag_main_image_posts_start: :environment do
      puts ''
      puts 'Перетаскиваем заглавные картинки для постов'

      ae_articles = AE_Article.all
      ae_articles_count = ae_articles.count
      num = 0

      ae_articles.each_with_index do | ae_article, index |       
        id = ae_article.id
        img_path = Dir[File.join(MAIN_IMAGE_POSTS_OLD_PATH,"#{id}.*")].select {|p| p =~ /\/.*\.(png)|(jp)|(PNG)/}.first

        if img_path
          post = find_post( ae_article )
          post.main_image = File.new img_path
          if post.save 
            print '*'.green
            num+=1
          else
            puts ''
            puts "Exception: Post with id: #{post.id}, title :'#{post.title}' not saved.".red
            puts_error post, index, ae_articles_count
          end
        else
          puts ''
          puts "File not exist: Article with id: #{id}, title :#{ae_article.title}.".red
        end
      end
      puts ''
      puts "Перенесено главных картинок для постов #{num} из #{ae_articles_count}".green
      puts ''
    end

    desc "Перетаскиваем заглавные картинки для блогов"
    task drag_main_image_blogs_start: :environment do
      puts ''
      puts 'Перетаскиваем заглавные картинки для блогов'

      ae_blogs = AE_Blog.all
      ae_blogs_count = ae_blogs.count
      num = 0

      ae_blogs.each_with_index do | ae_blog, index |       
        id = ae_blog.id
        next if id==98 # for file with strange name: '98.0'. Drag it manually
        
        img_path = Dir[File.join(MAIN_IMAGE_BLOGS_OLD_PATH,"#{id}.*")].select {|p| p =~ /\/.*\.(png)|(jp)|(JPG)|(0)|(PNG)/}.first

        if img_path
          post = find_post( ae_blog )
          post.main_image = File.new img_path
          if post.save 
            print '*'.green
            num+=1
          else
            puts ''
            puts "Exception: Blog post with id: #{post.id}, title :'#{post.name}' not saved.".red
            puts_error post, index, ae_blogs_count
          end
        else
          puts ''
          puts "File not exist: Blog with id: #{id}, title :#{ae_blog.name}.".red
        end
      end
      puts ''
      puts "Вручную надо перенести картинку со spoof именем '98.0' для блога 'Schizophrenia Taiwan 2.0' от 2013-11-28, путь: /public/system/blogs/original ".blue
      puts "Перенесено главных картинок для блогов #{num} из #{ae_blogs_count}".green
      puts ''
    end
  end
end
