# helpers
def create_system_hub slug, title, type
  User.root.hubs.where(title: title).first_or_create!(
    slug:  slug,
    title: title,
    pubs_type: type,
    state: :published
  )
end

def create_hub_category category
  user_root = User.root
  slug = make_slug category

  hub_category = Hub.new(
    title: category.title,
    # main_image_file_name: category.big_image_file_name,
    # main_image_content_type: category.big_image_content_type,
    # main_image_file_size: category.big_image_file_size,
    slug: slug,
    keywords: category.meta_keywords,
    description: category.meta_description.to_s[0..250],
    state: :published,
    user: user_root
  )
  hub_category
end

def find_parent_category category
  if category.respond_to?(:category_id)
    cat_id = category.category_id
    ae_category = AE_Category.where('id = ?', cat_id).first
  else
    cat_id = category.subcategory_id
    ae_category = AE_Subcategory.where('id = ?', cat_id).first
  end

  hub_category = Hub.where('slug = ?', ae_category.slug).first
  hub_category
end

def check_slug category
  hub = Hub.where('slug = ?', category.slug)
  hub.present?
end

def make_slug category
  if check_slug category
    parent_hub_category = find_parent_category category
    if parent_hub_category.present?
      "#{parent_hub_category.slug}-#{category.slug}"
    else
      salt = (0..8).map { (65 + rand(26)).chr }.join
      "#{salt}-#{category.slug}"
    end
  else
    category.slug
  end
end

def find_user node
  begin
    return_user node
  rescue
    User.root
  end
end

def return_user node
  ae_user = AE_User.find node.user_id
  user = User.where('username = ?', ae_user.nick)
  user.first
end

def create_comment node, parent = nil
  print '.'

  user = find_user node
  obj = return_obj_for_comment node

  root_comment = obj.comments.create!(
    user:        user,
    commentable: obj,
    raw_content: node.text,
    referer:     node.referer,
    user_agent:  node.user_agent,
    ip:          node.ip,
    parent_id:   parent.try(:id)
  )

  children = return_children_comment node
  children.each {|comment| create_comment comment, root_comment} if children.present?
end

def return_blog id
  begin
    blog = AE_Blog.find id
    return Post.find_by_title blog.name
  rescue ActiveRecord::RecordNotFound
    return false
  end
end

def return_article id
  begin
    article = AE_Article.find id
    return Post.find_by_title article.title
  rescue ActiveRecord::RecordNotFound
    return false
  end
end

def return_obj_for_comment comment
  obj = case comment.commentable_type
    when 'Blog' then return_blog comment.commentable_id
    when 'Article' then return_article comment.commentable_id
  end
end

def return_children_comment comment
  AE_Comment.where('parent_id = ?', comment.id)
end

def return_obj_for_storage node
  obj = case node.storage_type
    when 'Blog' then return_blog node.storage_id
    when 'Article' then return_article node.storage_id
  end
end

def create_attached_files node, old_file
  user = find_user node
  obj  = return_obj_for_storage node

  if obj && File.exists?(old_file)
    obj.attached_files.create(
      user: user,
      attachment: File.open(old_file)
    )
  else
    puts old_file.to_s.red
  end
end

def create_main_image_file obj, old_file
  if File.exists?(old_file)
    obj.main_image(main_image: File.open(old_file))
    print '(f*)' if obj.save
  else
    puts old_file.to_s.yellow
  end
end

def puts_error obj, index, obj_count
  puts ''
  puts "#{obj.errors.to_a.to_s.red} => #{index+1}/#{obj_count}"
  puts ''
end

def create_tags old_article, new_article
  tags = get_tags_by_context old_article, :names, :titles, :words
  new_article.name_list  = tags[:names ].join ','
  new_article.title_list = tags[:titles].join ','
  new_article.word_list  = tags[:words ].join ','
  new_article.save
end

def get_tags_by_context old_article, *contexts
  tags = {}
  contexts.each do | context |
    tags[ context ] = []
    result = AE_FullDatabase.connection.execute "select name from tags inner join taggings on tags.id = taggings.tag_id where taggable_id = #{old_article.id} and taggable_type='Article' and context='#{ context.to_s }'"
    result.each(as: :array)  do | row |
      row[0].gsub!( /\"/, "~" ) # "incompatible character encodings: ASCII-8BIT and UTF-8" monkey path for tags: Отель "Новая Роза", R'n"B, Метод Д"Апполито
      row[0].gsub!( /'/, "~" ) # "incompatible character encodings: ASCII-8BIT and UTF-8" monkey path for tags:
=begin 
      "198" "R'n'B"
      "271" "R'n""B"
      "364" "Destiny's Child"
      "442" "Raison d'etre"
      "806" "Метод Д'Апполито"
      "1864"  "Шинед О'Коннор"
      "1922"  "Dan D'Agostino"
=end


      tags[ context ]+= row
    end
  end
  tags
end

def compare_articles_quantity old_articles, new_articles
  old_count = old_articles.count
  new_count = new_articles.count
  if old_count == new_count
    0
  else
    [old_count, new_count]
  end
end

def compare_article_tags old_article, new_article
    tags = get_tags_by_context old_article, :names, :titles, :words
    if  
      (old_article.title  == new_article.title          ) && 
      (tags[:names ].sort == new_article.name_list.sort ) &&
      (tags[:words ].sort == new_article.word_list.sort ) &&
      (tags[:titles].sort == new_article.title_list.sort) 
    then
      true
    else
      false
    end
end
