def what_find
  ae_articles       = AE_Article.all
  # ae_articles       = AE_Article.find([13, 243])
end

namespace :ae do
  namespace :tags do
    desc "Drag tags from old to new base"
    task :drag  do
        %w[
          drag_start
          compare_equality
        ].each { |task| Rake::Task["ae:tags:#{task}"].invoke}
    end

    desc "Перетаскиваем теги"
    task drag_start: :environment do
      puts ''
      puts 'Перетаскиваем теги'
      puts "Чистим таблицы тегов"
      puts "Тэги очищены" if ActsAsTaggableOn::Tag.destroy_all
      puts "Полиморфная таблица тегов очищена" if ActsAsTaggableOn::Tagging.destroy_all

      ae_articles = what_find
      ae_articles_count = ae_articles.count

      ae_articles.each_with_index do |ae_article, index|

        post = Post.where title: ae_article.title
        post = post[0]
        create_tags ae_article, post

        if post.save
          puts "Article id #{ae_article.id} draged. (#{index+1}/#{ae_articles_count})".green
        else
          puts_error post, index, ae_articles_count
        end
      end
    end

    desc "Compare correct articles tags in old and new base"
    task compare_equality: :environment do
      %w[
        compare:article_quantity
        compare:tags_coincidence
      ].each { |task| Rake::Task["ae:tags:#{task}"].invoke}
    end

    namespace :compare do
      #не знаю зачем создал этот task. просто тренировался
      desc "Compare articles quantity"
      task article_quantity: :environment do
        old_articles = AE_Article.all
        new_articles = Post.where.not hub_id: [1, 36] # not system-article-categories or blogs

        puts "Compare articles quantity".blue
        result = compare_articles_quantity old_articles, new_articles
        if result == 0 
          puts "Counts equals".green
        else
          puts "Counts are different: old base ( #{result[0]} ), new base( #{result[1]})".red
        end
      end

      desc "Compare correct article tags in old and new bases"
      task tags_coincidence: :environment do
        puts "Compare correct article tags in old and new bases".blue
        ae_articles = what_find
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

          result = compare_article_tags( ae_article, post )

          if !result &&
            ae_article.id != 316 # monkey path for title"Norah Jones \"Feels Like Home\..". There are tags duplication in old base
            puts "(#{index+1}/#{ae_articles_count}) Tags are different for Article id: #{ ae_article.id }. Title #{ ae_article.title }".red
            exit
          end
          puts "Tags match in article (#{index+1}/#{ae_articles_count})".green
        end
        puts 'All tags match.'.green      end
    end
  end
end
