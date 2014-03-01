# =================================
# How to move future_articles data to new Engine?
# =================================
# Check or set ATTACHED_FILES_OLD_PATH
# rake ae:future_article_start
# =================================

ATTACHED_FILES_OLD_PATH=Rails.root+"public/system/articles/original/"

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
      print 'Перетаскиваем файлы прикрепленные к постам ( '
      print 'PDF'.green+', '
      print 'SWF'.blue+', '
      puts 'SWF see'.yellow+' )'

      ae_articles = AE_Article.all
      ae_articles_count = ae_articles.count
      num_pdf=0
      num_swf=0
      num_swf_see=0

      ae_articles.each_with_index do | ae_article, index |       
        id = ae_article.id
        post = find_post( ae_article )

        # PDF
        unless ae_article.pdf_file_name.nil?
          name = "pdf_#{id}.pdf"
          path = File.join(ATTACHED_FILES_OLD_PATH, name)
          if File.exist?(path)
            pdf = File.open path
            rec = post.attached_files.create attachment: pdf, description: ae_article.pdf_file_name

            if post.save 
              print '*'.green
              num_pdf+=1
            else
              puts ''
              puts "Exception PDF file: Post with id: #{post.id}, title :'#{post.title}' not saved.".red
              puts_error post, index, ae_articles_count
            end
          else
            puts ''
            puts "PDF file '#{name}' not exist: Article with id: #{id}, title :#{ae_article.title}.".red
          end
        end;

        # SWF
        unless ae_article.swf_file_name.nil?
          name = "swf_#{id}.swf"
          path = File.join(ATTACHED_FILES_OLD_PATH, name)
          if File.exist?(path)
            pdf = File.open path
            rec = post.attached_files.create attachment: pdf, description: ae_article.swf_file_name

            if post.save 
              print '*'.blue
              num_swf+=1
            else
              puts ''
              puts "Exception SWF file: Post with id: #{post.id}, title :'#{post.title}' not saved.".red
              puts_error post, index, ae_articles_count
            end
          else
            puts ''
            puts "SWF file '#{name}' not exist: Article with id: #{id}, title :#{ae_article.title}.".red
          end
        end;

        # SWF_see
        field = 'swf_see_file_name'
        unless eval "ae_article.#{field}.nil?"
          name = "swf_see_#{id}.swf"
          path = File.join(ATTACHED_FILES_OLD_PATH, name)
          if File.exist?(path)
            pdf = File.open path
            rec = post.attached_files.create attachment: pdf, description: eval("ae_article.#{field}")

            if post.save 
              print '*'.yellow
              num_swf_see+=1
            else
              puts ''
              puts "Exception SWF SEE file: Post with id: #{post.id}, title :'#{post.title}' not saved.".red
              puts_error post, index, ae_articles_count
            end
          else
            puts ''
            puts "SWF SEE file '#{name}' not exist: Article with id: #{id}, title :#{ae_article.title}.".red
          end
        end;
        print ' '
      end
      puts ''
      puts "Все файлы перетащены: pdf (#{num_pdf}), swf (#{num_swf}), swf_see (#{num_swf_see})".green
      puts ''
    end
  end
end