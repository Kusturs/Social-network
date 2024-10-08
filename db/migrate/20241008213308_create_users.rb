class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :first_name, null: false
      t.string :second_name
      t.string :last_name, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :last_name
    add_index :users, [:last_name, :first_name]
  end
end