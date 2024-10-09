require 'factory_bot_rails'

Comment.destroy_all
Post.destroy_all
User.destroy_all

2.times do
  FactoryBot.create(:user, :with_active_subscription)
end

2.times do
  FactoryBot.create(:user, :with_passive_subscription)
end

User.find_each do |user|
  FactoryBot.create_list(:post, 2, author: user)
end

User.find_each do |user|
  Post.find_each do |post|
    FactoryBot.create_list(:root_comment, 2, author: user, post: post)
  end
end

User.find_each do |user|
  Comment.root_comments.find_each do |comment|
    FactoryBot.create_list(:reply, 2, author: user, post: comment.post, parent: comment)
  end
end

# # Создаем 10 пользователей с профилями
# 10.times do
#   FactoryBot.create(:user, :with_profile)
# end

# # Создаем 5 активных пользователей с профилями, постами и комментариями
# 5.times do
#   FactoryBot.create(:user, :with_profile, :with_posts, :with_comments)
# end

# Создаем несколько пользователей с подписками
# users = User.all.sample(10)
# users.each do |user|
#   followers = users.sample(rand(1..5))
#   followers.each do |follower|
#     follower.follow(user) unless follower == user
#   end
# end
