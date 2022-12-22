class CreateArchiveNumbers < ActiveRecord::Migration
  def change
    create_table :archive_numbers do |t|      
      t.string  :cover_file_name

      t.string  :title
      t.text    :raw_content

      t.integer :number
      t.integer :year
      t.integer :month
      t.integer :number_in_year
    end
  end
end
