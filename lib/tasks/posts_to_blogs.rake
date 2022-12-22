namespace :posts2blogs do
  # rake posts2blogs:move
  task move: :environment do
    ids   = Hub.with_slug(:blogs).self_and_descendants.map(&:id)
    blogs = Post.where(hub: ids)
    blogs_count = blogs.count

    Blog.destroy_all
    blogs.each_with_index do |blog, index|
      Blog.create!(
        id: blog.id,
        user_id: blog.user_id,
        hub_id: blog.hub_id,
        title: blog.title,
        raw_intro: blog.raw_intro,
        intro: blog.intro,
        raw_content: blog.raw_content,
        content: blog.content,
        hub_state: blog.hub_state,
        legacy_url: blog.legacy_url,
        inline_name_tags: blog.inline_name_tags,
        inline_word_tags: blog.inline_word_tags,
        inline_title_tags: blog.inline_title_tags,
        published_at: blog.published_at,
        created_at: blog.created_at,
        updated_at: blog.updated_at,
        main_image_file_name: blog.main_image_file_name,
        main_image_content_type: blog.main_image_content_type,
        main_image_file_size: blog.main_image_file_size,
        main_image_updated_at: blog.main_image_updated_at,
        show_count: blog.show_count,
        state: blog.state,
        moderation_state: blog.moderation_state,
        moderator_note: blog.moderator_note,
        slug: blog.slug,
        short_id: blog.short_id,
        friendly_id: blog.friendly_id,
        storage_files_count: blog.storage_files_count,
        storage_files_size: blog.storage_files_size,
        draft_comments_count: blog.draft_comments_count,
        published_comments_count: blog.published_comments_count,
        deleted_comments_count: blog.deleted_comments_count,
        comments_switcher: blog.comments_switcher,

        main_image: (blog.main_image.present? ? File.open(blog.main_image.path) : nil)
      )

      puts "#{index}/#{blogs_count}/#{blog.id}"

      # cleanup object
      blog.update_column(:main_image_file_name, '')
      blog.destroy
    end
  end
end
