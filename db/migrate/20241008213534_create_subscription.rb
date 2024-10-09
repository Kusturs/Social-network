class CreateSubscription < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      add_column :users, :followers_count, :integer, default: 0
      add_column :users, :followed_users_count, :integer, default: 0
      
      t.timestamps
    end

    add_index :subscriptions, [:follower_id, :followed_id], unique: true
  end
end