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
      puts  'SWF see'.yellow+' )'

      ae_articles = AE_Article.all
      ae_articles_count = ae_articles.count
      num_pdf=0
      num_swf=0
      num_swf_see=0

      ae_articles.each_with_index do |ae_article, index|
        id   = ae_article.id
        post = find_post(ae_article)

        if post
          # PDF
          if ae_article.pdf_file_name
            file_name = "pdf_#{ id }.pdf"
            path = File.join(ATTACHED_FILES_OLD_PATH, file_name)

            if File.exist?(path)
              pdf = File.open path
              
              af = post.attached_files.create!(
                attachment: pdf,
                description: ae_article.pdf_file_name
              )

              puts [ae_article.title, ae_article.id].join " -> "
              puts [post.title, post.id].join " -> "
              puts file_name
              puts af.attachment.path
              puts "-" * 20

              num_pdf = num_pdf.next
            end
          end

          # SWF
          if ae_article.swf_file_name
            name = "swf_#{ id }.swf"
            path = File.join(ATTACHED_FILES_OLD_PATH, name)

            if File.exist?(path)
              swf = File.open path

              af = post.attached_files.create!(
                attachment: swf,
                description: ae_article.swf_file_name
              )

              puts [ae_article.title, ae_article.id].join " -> "
              puts [post.title, post.id].join " -> "
              puts name
              puts af.attachment.path
              puts "-" * 20

              num_swf = num_swf.next
            else
              puts ''
              puts "SWF file '#{ name }' not exist: Article with id: #{ id }, title :#{ ae_article.title }.".red
            end
          end

          # SWF_see
          if ae_article.swf_see_file_name
            see_name = "swf_see_#{ id }.swf"
            path = File.join(ATTACHED_FILES_OLD_PATH, see_name)

            if File.exist?(path)
              file = File.open path
              af = post.attached_files.create!(
                attachment: file,
                description: ae_article.swf_see_file_name
              )

              puts [ae_article.title, ae_article.id].join " -> "
              puts [post.title, post.id].join " -> "
              puts see_name
              puts af.attachment.path
              puts "-" * 20

              num_swf_see = num_swf_see.next
            else
              puts ''
              puts "SWF SEE file '#{ see_name }' not exist: Article with id: #{ id }, title :#{ ae_article.title }.".red
            end
          end
        else
          puts "Post: #{ ae_article.title } not found".red
        end

      end
      puts ''
      puts "Все файлы перетащены: pdf (#{num_pdf}), swf (#{num_swf}), swf_see (#{num_swf_see})".green
      puts ''
    end
  end
end