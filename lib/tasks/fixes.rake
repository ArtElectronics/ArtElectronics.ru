namespace :fixes do
  # rake fixes:change_name_order
  task change_name_order: :environment do
    Author.all.each do |author|
      author.name = author.name.split(' ').reverse.join ' '
      author.save
    end
  end

  # rake fixes:define_authors_letter
  task define_authors_letter: :environment do
    Author.all.each do |author|
      if author.first_letter.blank?
        author.first_letter = author.name.split(' ').last.first.mb_chars.upcase.to_s
        puts "#{ author.name } => #{ author.first_letter }"
        author.save
      end
    end
  end

  # rake fixes:post_blog_comments
  task post_blog_comments: :environment do
    post_ids = Post.all.map do |post|
      post.id if post.published_comments_count != post.comments.published.count
    end.compact

    # POSTS: 773, 775, 780
    puts Comment.where(commentable_id: post_ids).update_all(commentable_type: :Post)

    blog_ids = Blog.all.map do |blog|
      blog.id if blog.published_comments_count != blog.comments.published.count
    end.compact
  end

  # rake fixes:blog_comments
  task blog_comments: :environment do
    ids = Blog.published.pluck(:id)
    comments = Comment.where(commentable_id: ids)
    comments.update_all(commentable_type: :Blog)
    puts "Blog comments fixed"
  end
end
