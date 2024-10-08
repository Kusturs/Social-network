require 'factory_bot_rails'

# Очистка базы данных перед сидингом (опционально)
if Rails.env.development?
  User.destroy_all
  Post.destroy_all
  Comment.destroy_all
end

# Создание администратора
FactoryBot.create(:user, :admin,
  username: 'admin',
  email: 'admin@example.com',
  password: 'adminpassword',
  password_confirmation: 'adminpassword'
)

# Создание обычных пользователей
10.times do
  FactoryBot.create(:user)
end

# Создание пользователей с постами
5.times do
  FactoryBot.create(:user, :with_posts)
end

# Создание комментариев
User.all.each do |user|
  Post.all.sample(3).each do |post|
    FactoryBot.create(:comment, user: user, post: post)
  end
end

puts "Seed data created successfully!"