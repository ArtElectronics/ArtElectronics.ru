after 'development:roles' do
  10.times do |i|
    name  = Faker::Name.name
    login = Faker::Internet.user_name
    email = "#{login}@gmail.com"

    user = User.create!(
      login: login,
      username: name,
      email:    email,
      password: "password#{i.next}"
    )
    # with different roles
    role_name = [:blogger, :blogger, :author].sample
    user.update_attributes(role: Role.with_name(role_name))

    puts "User #{i.next} role:#{role_name} created"
  end

  # set Admin
  # update with validations
  User.first.update_attributes(role: Role.with_name(:admin))
  puts "Admin set"
end