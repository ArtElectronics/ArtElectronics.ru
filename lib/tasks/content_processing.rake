namespace :content_processing do
  # rake content_processing:reprocess
  task reprocess: :environment do
    admin = User.first

    [ Post, Blog, Page ].each do |klass|
      kc = klass.count

      klass.all.each_with_index do |pub, index|
        pub.content_processing_for(admin)
        pub.save!

        puts "#{ klass.to_s } => #{ index.next }/#{ kc }"
      end
    end
  end
end
