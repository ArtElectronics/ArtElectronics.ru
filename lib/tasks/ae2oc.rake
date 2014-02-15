require "#{Rails.root}/lib/tasks/includes/connect_ae_db"
require "#{Rails.root}/lib/tasks/includes/ae2oc_db"
require "#{Rails.root}/lib/tasks/includes/helpers"

# =================================
# How to move data to new Engine?
# =================================
# rake ae:data_move
# =================================

# FILE_DUMP_DIR = "#{Rails.root}/public/system"
FILE_DUMP_DIR = "/home/the_teacher/vbox/system"

# проверить путь и права на переносимые файлы перед стартом
# rake ae:user_start
namespace :ae do
  desc "Clean up DB"
  task clean_db: :environment do
    puts "Роли очищены"              if Role.destroy_all
    puts "Пользователи очищены"      if User.destroy_all
    puts "Хабы очишены"              if Hub.delete_all
    puts "Посты очищены"             if Post.delete_all
    puts "Комменты очищены"          if Comment.delete_all
    puts "Загруженные файлы очищены" if AttachedFile.delete_all
  end

  desc "Create Role"
  task create_roles: [:environment, :clean_db] do
    admin_role = Role.create!(
      name: :admin,
      title: "Admin Role",
      description: "Admin can do anything"
    )

    blogger = Role.create!(
      name: :blogger,
      title: "Blogger role",
      description: "Blogger can manage his Comments and post in Blog hub"
    )

    author = Role.create!(
      name: :author,
      title: "Author role",
      description: "Blogger can manage his Comments and Post in Few Hubs (Articles, Blogs, Recipes, Videos)"
    )

    #######################################################
    # Update Role's Abilities
    #######################################################

    admin_role.create_rule(:system, :administrator)
    admin_role.rule_on(:system, :administrator)

    blogger.update_role(
      users: {
        cabinet: true
      },
      posts: {
        new:     true,
        create:  true,
        edit:    true,
        update:  true,
        rebuild: true,
        destroy: true
      },
      available_hubs: {
        blogs: true
      }
    )

    author.update_role(
      users: {
        cabinet: true
      },
      posts: {
        new:     true,
        create:  true,
        edit:    true,
        update:  true,
        rebuild: true,
        destroy: true
      },
      available_hubs: {
        blogs:    true,
        videos:   true,
        recipes:  true,
        articles: true,
        interviews: true
      }
    )

    puts "Roles created"
  end

  desc "Перетягиваем пользователей"
  task user_start: [:environment, :create_roles] do
    puts "User start =>"
    ae_users = AE_User.all
    # ae_users = AE_User.limit(2)
    user_count = ae_users.count

    # create admin
    admin = User.new(
      login: 'admin',
      username: 'admin',
      email: 'admin@example.com',
      password: 'admin',
      role: Role.with_name(:admin)
    )

    if admin.save
      puts "Admin успешно создан"
    else
      puts "#{admin.errors.to_a.to_s.red}"
    end

    puts "Users export"
    ae_users.each_with_index do |aeuser, index|
      user = User.new(
        login: aeuser.email,
        username: aeuser.nick,
        email: aeuser.email,
        role_id: 2,
        created_at: aeuser.created_at,
        updated_at: aeuser.updated_at,
        password: 'password'
      )

      if user.save
        print '*'
        # puts "#{aeuser.nick} => #{index+1}/#{user_count}"
      else
        puts_error aeuser, index, user_count
      end
    end
  end

  desc "Создаем основной hub для категорий статей"
  task create_root_category_hub: [:environment] do
    # Hub.delete_all
    puts ''
    puts "Создаем основной hub для категорий статей"
    create_system_hub(:system_article_categories, "КатегорииСтатей", :categories)
  end

  desc "Перетаскиваем категории в основной hub для категорий статей"
  task categories_start: [:environment] do
    ae_categories = AE_Category.all
    ae_categories_count = ae_categories.count

    # перетягиваем подкатегории
    puts ''
    ae_subcategories = AE_Subcategory.all
    ae_subcategories_count = ae_subcategories.count

    root_hub_categories = Hub.where(title: "КатегорииСтатей").first

    ae_categories.each_with_index do |ae_category, index|
      hub_category = create_hub_category ae_category

      if hub_category.save
        hub_category.move_to_child_of root_hub_categories

        print "*"
        # puts "#{ae_category.slug} => #{index+1}/#{ae_categories_count}"
        puts ''
        puts "Перетягиваем подкатегории для #{ae_category.slug}"

        ae_subcategories.each_with_index do |ae_subcategory, index|
          hub_subcategory = create_hub_category ae_subcategory

          if ae_subcategory.category_id == ae_category.id
            if hub_subcategory.save
              hub_subcategory.move_to_child_of hub_category
              print '*'
              # puts "#{hub_subcategory.slug} => #{index+1}/#{ae_subcategories_count}"
            else
              puts_error hub_subcategory, index, ae_subcategories_count
            end
          else
            next
          end
        end
      else
        puts_error ae_category, index, ae_categories_count
      end
    end
  end

  desc "Перетаскиваем посты"
  task posts_start: [:environment] do
    puts ''
    puts 'Перетаскиваем посты'

    ae_articles       = AE_Article.all
    ae_articles_count = ae_articles.count

    ae_articles.each_with_index do |ae_article, index|
      # user = find_user ae_article
      user = User.root
      hub = find_parent_category ae_article

      # решить вопрос с: image_file_name, pdf_file_name, swf_file_name, swf_see_file_name
      post = Post.new(
        user_id: user.id,
        hub_id: hub.id,
        keywords: ae_article.meta_keywords,
        description: ae_article.meta_description.to_s[0..250],
        title: ae_article.title,
        raw_intro: ae_article.description,
        raw_content: ae_article.body,
        state: ae_article.state
      )

      if post.save
        old_file = "#{FILE_DUMP_DIR}/articles"+
                   "/original/#{ae_article.id}#{File.extname(ae_article.image_file_name)}"

        # create_main_image_file post, old_file
        puts "(#{index+1}/#{ae_articles_count})"
      else
        puts_error post, index, ae_articles_count
      end
    end
  end

  desc "Создаем Hub для блогов"
  task create_hub_blog: [:environment] do
    puts ''
    puts "Создаем основной hub для блогов"
    create_system_hub(:system_blogs, "Блоги", :posts)
  end

  desc "Перетягиваем блоги"
  # допилить не связанные 3 блога, связать с админом
  task blogs_start: [:environment] do
    ae_blogs = AE_Blog.where.not('user_id IN (4,17,33)')
    ae_blogs_count = ae_blogs.count
    hub_blog = Hub.roots.where("title = ?", "Блоги").first

    puts ''
    puts "Перетягиваем блоги:"
    ae_blogs.each_with_index do |ae_blog, index|
      user_blog = find_user ae_blog

      blog = Post.new(
        title: ae_blog.name,
        raw_intro: ae_blog.body,
        raw_content: ae_blog.body,
        hub_id: hub_blog.id,
        user_id: user_blog.id
      )

      if blog.save
        print "*"
        old_file = "#{FILE_DUMP_DIR}/blogs"+
           "/original/#{ae_blog.id}#{File.extname(ae_blog.image_file_name.to_s)}"
        # create_main_image_file blog, old_file
      else
        puts_error blog, index, ae_blogs_count
      end
    end

    not_relation_blogs = AE_Blog.where('user_id IN (4,17,33)')
    not_relation_blogs.each_with_index do |bl, index|
      old_file = "#{FILE_DUMP_DIR}/blogs"+
                 "/original/#{bl.id}#{File.extname(bl.image_file_name)}"

      blog = Post.new(
        title: bl.name,
        raw_intro: bl.body,
        raw_content: bl.body,
        hub_id: hub_blog.id,
        user_id: User.root
      )

      if blog.save
        print "*"
        # create_main_image_file blog, old_file
      else
        puts_error blog, index, not_relation_blogs.count
      end
    end
  end

  desc "Перетягиваем комментарии"
  task comment_start: [:environment] do
    puts ''
    puts 'Перетаскиваем комментарии:'
    ae_roots_comments = AE_Comment.where('depth = ?', 0)
    ae_roots_comments.each {|ae_root_comment| create_comment ae_root_comment}
  end

  desc "Перетягиваем загруженные файлы (uploaded_files)"
  task uploaded_files_start: [:environment] do
    puts ''
    puts 'Перетаскиваем загруженные файлы (uploaded_files)'
    ae_uploaded_files = AE_UploadedFile.all
    upfiles_count     = ae_uploaded_files.count
    # ae_uploaded_files = AE_UploadedFile.limit(5)

    ae_uploaded_files.each_with_index do |ae_uploaded_file, index|
      # Положил в папку с проектом, указывать путь под себя
      old_file = "#{FILE_DUMP_DIR}/uploads/" +
                  "#{ae_uploaded_file.storage_type.downcase}/#{ae_uploaded_file.storage_id}/"+
                  "files/original/#{ae_uploaded_file.file_file_name}"

      # create_attached_files ae_uploaded_file, old_file
      puts "UpFile #{index}/#{upfiles_count}"
    end
  end

  desc "Перетягиваем теги из AE в Open-cook"
  task tags_start: :environment do
  end

  desc "Перетягивем  авторов и проверяем корректность"
  task :authors_start  do
      %w[
        drag_authors
        compare_authors_equality
      ].each { |task| Rake::Task["ae:#{task}"].invoke}
  end

  desc "Перетягиваем авторов"
  task drag_authors: :environment do
    puts ''
    puts "Перетягиваем авторов"
    puts ''
    puts "Авторы очищены" if Author.destroy_all
    puts "Join таблица \"посты-авторы\" очищена" if Authorship.destroy_all
    ae_authors = AE_Author.all
    # ae_authors = AE_Author.limit 2
    articles_count = 0
    author_count = ae_authors.count

    ae_authors.each_with_index do |ae_author, index|
      author = Author.new(
        name: ae_author.name,
        description: ae_author.description,
        short_description: ae_author.short_description,
        created_at: ae_author.created_at,
        updated_at: ae_author.updated_at,
      )

      if author.save
        print '*'
      else
        puts_error ae_author, index, author_count
        next
      end

      ae_titles = get_article_titles( ae_author )

      ae_titles.each do | ae_title |
        post = find_post Post.where( title: ae_title ).first
        post.authors << author
        articles_count += 1
      end
    end
    puts ''
    puts "Articles assigment: #{ articles_count }"
  end

  desc "Проверка корректность переноса авторов"
  task compare_authors_equality: :environment do  
    puts "Проверяем корректность ассоциации перенесенных авторов с постами".blue
    # ae_articles = AE_Article.find [13, 58]
    ae_articles = AE_Article.all
    ae_articles_count = ae_articles.count
 
    ae_articles.each_with_index do | ae_article, index |
      # in the bases not unique fields, because I looking for by :title
      post = Post.where title: ae_article.title
      
      if post.count == 0 then
        puts "post for article #{ae_article.id} not found".red; 
        next;
      end

      if post.count > 1
        puts "Stop. Title for old article not unique in new base.".red
        puts "#{ ae_article.inspect }".yellow
        exit
      end

      post = post[0]
      authors = post.authors
      
      if authors == []  
        puts "Author for article #{ ae_article.id } no exist. ".red
        next
      end  

      ae_author = AE_Author.find( ae_article.author_id )
      if  ( authors.count == 1 ) && 
          ( authors.first.name == ae_author.name ) &&
          ( authors.first.description == ae_author.description )
      then 
        print '.'.green
      else
        puts "Post #{ post.id } for article #{ ae_article.id } has incorrect author".red
      end
    end
    puts ''
  end

  # rake ae:data_move
  desc "data moving"
  task data_move: :environment do
    Rake::Task["db:bootstrap"].invoke
    %w[
      clean_db
      user_start
      create_root_category_hub
      categories_start    
      posts_start
      create_hub_blog
      blogs_start
      comment_start
      tags_start
      authors_start
    ].each{ |task| Rake::Task["ae:#{task}"].invoke }
    # uploaded_files_start
  end
end
