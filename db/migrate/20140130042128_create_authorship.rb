class CreateAuthorship < ActiveRecord::Migration
  def change
    create_table :authorships do |t|
      t.references :post,   index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
