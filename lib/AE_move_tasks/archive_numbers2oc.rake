# =================================
# How to move archive_numbers data to new Engine?
# =================================
# Check or set ARCHIVE_FILES_OLD_PATH
# rake ae:archive_numbers_start
# =================================

ARCHIVE_FILES_OLD_PATH = Rails.root + "public/system/archive_numbers/original/"

namespace :ae do
  desc "Drag archive attached files to new base"
  task :archive_numbers_start do
      %w[
        drag_archive_numbers
      ].each { |task| Rake::Task["ae:archive_numbers:#{task}"].invoke}
  end

  namespace :archive_numbers do
    desc 'Перетаскиваем файлы обложек архивных номеров'
    task drag_archive_numbers: :environment do
      puts ''
      puts ''
      print 'Перетаскиваем файлы обложек архивных номеров'
      puts ''; puts ''

      old_archives = AE_ArchiveNumber.order :n

      old_archive_count = old_archives.count
      files_num = 0

      old_archives.each_with_index do |o, idx|

        fname = "#{ o.id }.jpg"
        path = File.join(ARCHIVE_FILES_OLD_PATH, fname)
        file = File.open path
        cont = File.read Rails.root + "lib/archive_content/#{ idx.next }.html"

        archive = ArchiveNumber.create!(
          number:    o.n,
          month:     o.month,
          year:      o.year,
          raw_content: cont,
          number_in_year: o.in_year_n,
          cover:     file
        )

        print "N-#{ archive.number }  ".green
        print 
        "#{ puts archive.cover.url }"

        files_num += 1
      end

      puts ''
      puts "Все файлы обложек архивов перенесены : (#{files_num})".green
      puts ''
    end
  end
end
