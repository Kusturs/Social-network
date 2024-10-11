require 'factory_bot_rails'

Comment.destroy_all
Post.destroy_all
User.destroy_all

2.times do
  FactoryBot.create(:user, :with_profile, :with_active_subscription)
end

2.times do
  FactoryBot.create(:user, :with_profile, :with_passive_subscription)
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

