class CreateAuthor < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.text :short_description
      t.references :user, index: true

      t.timestamps
    end
  end
end
