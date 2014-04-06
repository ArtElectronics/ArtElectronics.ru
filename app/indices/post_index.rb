ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes title
  indexes intro
  indexes content

  where "state = 'published'"

  has user_id, published_at, created_at, updated_at
end
