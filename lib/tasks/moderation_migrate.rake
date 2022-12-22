namespace :moderation do
  # rake moderation:migrate
  task migrate: :environment do
    Post.update_all(moderation_state: :moderated)
    Blog.update_all(moderation_state: :moderated)
    Page.update_all(moderation_state: :moderated)
  end
end
