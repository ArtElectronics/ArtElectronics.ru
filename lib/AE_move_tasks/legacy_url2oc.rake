# =================================
# How to move legacy url data to new Engine?
# =================================
# rake ae:legacy_url_start
# =================================

namespace :ae do
  desc "Drag legacy url to new base"
  task :legacy_url_start do
      %w[
        drag_url_post_start
        drag_url_category_start
        drag_url_subcategory_start
      ].each { |task| Rake::Task["ae:legacy_url:#{task}"].invoke}
  end

  namespace :legacy_url do
    desc "Перетаскиваем legacy_url для постов"
    task drag_url_post_start: :environment do
      puts ''
      puts 'Перетаскиваем legacy_url для постов'

      ae_articles = AE_Article.all
      ae_articles_count = ae_articles.count

      ae_articles.each_with_index do | ae_article, index |
        legacy_url = get_legacy_url( ae_article ).join '/'
        
        post = find_post( ae_article )
        post.legacy_url = legacy_url
        if post.save 
          print '*'
        else
          puts_error post, index, ae_articles_count
        end
      end  
      puts ''
    end

    desc "Перетаскиваем legacy_url для категорий"
    task drag_url_category_start: :environment do
      puts ''
      puts 'Перетаскиваем legacy_url для категорий'

      ae_categories = AE_Category.all
      ae_categories_count = ae_categories.count

      ae_categories.each_with_index do | ae_category, index |
        legacy_url = "#{ae_category.slug}"
        hub = Hub.where( slug: ae_category.slug).first

        hub.legacy_url = legacy_url
        if hub.save 
          print '*'
        else
          puts_error hub, index, ae_categories_count
        end
      end  
      puts ''
    end

    desc "Перетаскиваем legacy_url для субкатегорий"
    task drag_url_subcategory_start: :environment do
      puts ''
      puts 'Перетаскиваем legacy_url для субкатегорий'

      ae_subcategories = AE_Subcategory.all
      ae_subcategories_count = ae_subcategories.count

      ae_subcategories.each_with_index do | ae_subcategory, index |
        
        ae_category = AE_Category.where(id: ae_subcategory.category_id).first
        legacy_url = "#{ae_category.slug}/#{ae_subcategory.slug}"

        slug = get_subcategory_slug( ae_category, ae_subcategory )

        hub = Hub.where( slug: slug).first

        hub.legacy_url = legacy_url
        if hub.save 
          print '*'
        else
          puts_error hub, index, ae_subcategories_count
        end
      end  
      puts ''
    end

    desc "Сверка разбивки перенесенных статей по категориям"
    task check_posts_by_hub: :environment do
      puts ''
      puts 'Сверка разбивки перенесенных статей по категориям'

      ae_subcategories = AE_Subcategory.all
      ae_subcategories_count = ae_subcategories.count

      ae_subcategories.each_with_index do | ae_subcategory, index_subcategory |
        ae_category = AE_Category.where(id: ae_subcategory.category_id).first
        legacy_url = "#{ae_category.slug}/#{ae_subcategory.slug}"
        ae_articles = AE_Article.where(subcategory_id: ae_subcategory.id)
        s_hub = Hub.where(legacy_url: legacy_url).first
        oc_posts = s_hub.posts
        
        ae_titles=ae_articles.map(&:title)
        oc_titles=oc_posts.map(&:title)

        if ae_titles==oc_titles
          puts "#{ae_subcategory.id}: #{legacy_url} - ok (#{ae_titles.count}-#{oc_titles.count})".green
        else
          puts "#{ae_subcategory.id}: #{legacy_url} - bad (#{ae_titles.count}-#{oc_titles.count})".red
          puts "Process data moving to new base stopped.".red
          exit
        end
      end  
      puts ''
    end
  end
end
