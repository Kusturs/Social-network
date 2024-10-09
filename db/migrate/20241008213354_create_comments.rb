class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :author, foreign_key: { to_table: :users, on_delete: :nullify }
      t.references :post, foreign_key: { on_delete: :nullify }
      t.references :parent, null: true, foreign_key: { to_table: :comments, on_delete: :nullify }
      t.text :content, null: false

      t.timestamps
    end

    add_index :comments, [:post_id, :created_at]
  end
end
