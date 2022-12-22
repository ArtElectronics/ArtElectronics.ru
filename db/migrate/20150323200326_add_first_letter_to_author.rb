class AddFirstLetterToAuthor < ActiveRecord::Migration
  def change
    add_column :authors, :first_letter, :string, default: ''
  end
end
