class CreateAuthor < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.references :user, index: true

      t.string :name
      t.string :avatar_file_name
      t.text :short_description
      t.text :description

      t.timestamps
    end
  end
end
