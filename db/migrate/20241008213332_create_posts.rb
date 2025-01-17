class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.integer :comments_count, default: 0

      t.timestamps
    end

    add_index :posts, :created_at
  end
end
