# =================================
# How to move future_articles data to new Engine?
# =================================
# rake ae:future_article_start
# =================================

MAIN_FUTURE_FILES_OLD_PATH=Rails.root+"public/system/articles/original/"

namespace :ae do
  desc "Drag article attached files to new base"
  task :future_article_start do
      %w[
        drag_future_article_start
      ].each { |task| Rake::Task["ae:future_article:#{task}"].invoke}
  end

  namespace :future_article do
    desc 'Перетаскиваем файлы прикрепленные к постам'
    task drag_future_article_start: :environment do
      puts ''
      puts 'Перетаскиваем файлы прикрепленные к постам'

      ae_articles = AE_Article.all
      ae_articles_count = ae_articles.count
      num_pdf=0

      ae_articles.each_with_index do | ae_article, index |       
        id = ae_article.id
        post = find_post( ae_article )

        unless ae_article.pdf_file_name.nil?
          # if id!=13
            path = File.join(MAIN_FUTURE_FILES_OLD_PATH,"pdf_#{id}.pdf")
          # else
            # path = File.join(MAIN_FUTURE_FILES_OLD_PATH,"pdf_#{id}.pdf")
          # end
          if File.exist?(path)
            pdf = File.open path
            post.attached_files.create attachment: pdf

            if post.save 
              print '*'.green
              num_pdf+=1
            else
              puts ''
              puts "Exception: Post with id: #{post.id}, title :'#{post.title}' not saved.".red
              puts_error post, index, ae_articles_count
            end
          else
            puts ''
            puts "PDF file not exist: Article with id: #{id}, title :#{ae_article.title}.".red
          end

        end;

      end
      puts ''
      puts "Все файлы перетащены: pdf (#{num_pdf})".green
      puts ''
    end
  end
end