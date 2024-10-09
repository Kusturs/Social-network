class AddJtiToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :jti, :string, null: false
    add_index :profiles, :jti, unique: true
  end
end
