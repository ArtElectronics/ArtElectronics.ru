# encoding: UTF-8

User.destroy_all
Role.destroy_all

Hub.destroy_all

Post.destroy_all
Page.destroy_all
Blog.destroy_all
Note.destroy_all
Article.destroy_all

Recipe.destroy_all
Comment.destroy_all

#######################################################
# Create Roles
#######################################################

  # Admin
  Role.create!(
    name: :admin,
    title: "Admin Role",
    description: "Role for admin",
    the_role: {
      system: { administrator: true }
    }.to_json
  )

  # Author
  roles_set = {}
  roles_set[:users] = { cabinet: true }
  [:pages, :posts, :articles, :recipes, :blogs].each do |name|
    roles_set[name] = {
      index:   true,
      new:     true,
      create:  true,
      show:    true,
      edit:    true,
      update:  true,
      rebuild: true,
      destroy: true
    }
  end

  Role.create!(
    name: :author,
    title: "Author Role",
    description: "Role for Authors",
    the_role: roles_set.to_json
  )

  # User
  Role.create!(
    name: :user,
    title: "User Role",
    description: "Role for Users",
    the_role: {
      users: {
        cabinet: true
      }
    }.to_json
  )

puts "Roles created"

######################################################
# Create Users
######################################################
5.times do |i|
  name  = Faker::Name.name
  login = name.downcase.gsub(/[\ \._]/, '-')
  email = "#{login}@gmail.com"

  user = User.create!(
    username: name,
    login:    login,
    email:    email,
    password: "password#{i.next}"
  )
  # with different roles
  role_name = [:user, :user, :author].sample
  user.update_attributes(role: Role.with_name(role_name))

  puts "User #{i.next} role:#{role_name} created"
end

# set Admin
# update with validations
User.first.update_attributes(role: Role.with_name(:admin))

#####################################
# PAGES
#####################################
def create_system_pages_hub
  User.root.hubs.create!(
    title: :system_pages,
    hub_type: :pages
  )
end

def create_system_pages
  system_hub = Hub.where(title: :system_pages).first

  system_hub.pages.create!(
    title: "О проекте",
    slug: :about,
    raw_content: Faker::Lorem.paragraphs(3).join
  )

  system_hub.pages.create!(
    title: "О компании",
    slug: :company,
    raw_content: Faker::Lorem.paragraphs(3).join
  )

  system_hub.pages.create!(
    title: "Команда",
    slug: :team,
    raw_content: Faker::Lorem.paragraphs(3).join
  )

  system_hub.pages.create!(
    title: "Пользовательское соглашение",
    slug: :agreement,
    raw_content: Faker::Lorem.paragraphs(3).join
  )
end

create_system_pages_hub
create_system_pages

#####################################
# BLOGS
#####################################
def create_blog_hubs
  %w{ 2012 2013 }.each do |year|
    (1..12).to_a.each do |month|
      User.root.hubs.create!(
        title: "#{Time.now.year}-#{Time.now.month}",
        hub_type: :blogs
      )
    end
  end
end

def create_blogs count
  users = User.all
  blog_hubs = Hub.of_(:blogs).all

  count.times do |index|
    user = users.sample
    blog = user.blogs.create!(
      title: "Blog #{index.next} (u:#{user.id})",
      raw_intro: Faker::Lorem.paragraphs(3).join,
      raw_content: Faker::Lorem.paragraphs(3).join
    )
    blog.send("to_#{[:draft, :published, :deleted].sample}")
    blog.update!(hub: blog_hubs.sample)
    puts "Blog created #{index}"
  end
end

create_blog_hubs
create_blogs 30

#####################################
# Recipes
#####################################

def create_recipes_hubs
  [
    "Блины",
    "Интервью",
    "Статьи",
    "Детские рецепты Марии Панковой",
    "Открытая кухня Ольги Космос",
    "Заготовки",
    "Супы",
    "На второе",
    "Салаты",
    "Рыба",
    "Гарниры",
    "Овощи",
    "Вкусняшки к чаю",
    "Кухня мужика",
    "Напитки",
    "Птица с подворья",
    "К завтраку",
    "Закуски",
    "Ликеры и Сиропы",
    "Выпечка несладкая",
    "Соусы, дипы",
    "Десерты",
    "Кремы"
  ].each do |title|
    User.root.hubs.create!(title: title, hub_type: :recipes)
  end
end

def create_recipes count
  users = User.all
  recipes_hubs = Hub.of_(:recipes).all

  count.times do |index|
    user = users.sample
    hub  = recipes_hubs.sample

    recipe = user.recipes.create!(
      hub: hub,
      title: Faker::Lorem.sentence,
      raw_intro: Faker::Lorem.paragraphs(3).join,
      raw_content: Faker::Lorem.paragraphs(3).join
    )
    recipe.send("to_#{[:draft, :published, :deleted].sample}")
    puts "Recipe created #{index}"
  end
end

create_recipes_hubs
create_recipes 300

######################################################
# Create data for authors
######################################################
# User.with_role(:admin).each_with_index do |user, u|
#   3.times do |m|
#     create_hub(:posts, m.next, :posts, user, u.next)
#     create_blogs 30
#     # create_hub(:blogs, m.next, :blogs, user, u.next)
#     # create_hub(:pages, m.next, :pages, user, u.next)
#     # create_hub(:notes, m.next, :notes, user, u.next)
#     # create_hub(:articles, m.next, :articles, user, u.next)
#     # create_hub(:recipes, m.next, :recipes, user, u.next)
#   end
# end

# # User.with_role(:author).each_with_index do |user, u|
# #   3.times do |m|
# #     create_hub(:posts, m.next, :posts, user, u.next)
# #     create_hub(:blogs, m.next, :blogs, user, u.next)
# #     create_hub(:pages, m.next, :pages, user, u.next)
# #     create_hub(:notes, m.next, :notes, user, u.next)
# #     create_hub(:articles, m.next, :articles, user, u.next)
# #     create_hub(:recipes, m.next, :recipes, user, u.next)
# #   end
# # end

# def create_comment post, parent_comment = nil
#   owner = [User.all.sample, nil].sample

#   comment = post.comments.create!(
#     user:        owner,
#     commentable: post,
#     title:       Faker::Lorem.sentence,
#     contacts:    Faker::Lorem.sentence,
#     raw_content: Faker::Lorem.paragraphs(4).join,
#     parent_id:   parent_comment.try(:id)
#   )

#   puts "Comment created #{parent_comment.try(:id)}"
#   puts "Default Comment state => #{comment.state}"

#   st = [:draft, :published].sample
#   puts "to => #{st}"
#   comment.send("to_#{st}")

#   comment
# end

# Post.all.each do |post|
#   3.times do
#     parent = create_comment(post)
#     3.times do
#       parent = create_comment(post, parent)
#       3.times do
#         create_comment(post, parent)
#       end
#     end
#   end
# end

# Blog.first do |post|
#   3.times do
#     parent = create_comment(post)
#     3.times do
#       parent = create_comment(post, parent)
#       3.times do
#         create_comment(post, parent)
#       end
#     end
#   end
# end

# Comment.all.shuffle[0..40].each do |comment|
#   comment.to_deleted
#   puts "C: #{comment.id} => to deleted"
# end

######################################################
# Info fn
######################################################
def hub_info(type)
  puts "Hub of #{type} count: #{Hub.of_(type).count}"
  puts "Hub of #{type} published count: #{Hub.of_(type).with_state(:published).count}"
  puts "Hub of #{type} draft count: #{Hub.of_(type).with_state(:draft).count}"
  puts "~" * 20
end

def model_info model
  puts "#{model} count: #{model.count}"
  puts "#{model} published count: #{model.with_state(:published).count}"
  puts "#{model} draft count: #{model.with_state(:draft).count}"
  puts "#{model} deleted count: #{model.with_state(:deleted).count}"
  puts "~" * 20
end
######################################################
# Create data for authors
######################################################
_num = 20
puts "~" * _num

puts "Total User count: #{User.count}"
puts "~" * _num

puts "Admins count: #{User.with_role(:admin).count}"
puts "Authors count: #{User.with_role(:author).count}"
puts "Users count: #{User.with_role(:user).count}"
puts "~" * _num

puts "Hubs count: #{Hub.count}"
puts "~" * _num

hub_info(:pages)
model_info(Page)

hub_info(:posts)
model_info(Post)

hub_info(:blogs)
model_info(Blog)

hub_info(:notes)
model_info(Note)

hub_info(:articles)
model_info(Article)

hub_info(:recipes)
model_info(Recipe)

model_info(Comment)