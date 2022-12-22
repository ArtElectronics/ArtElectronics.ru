# This migration comes from the_banners_engine (originally 20141215103839)
class TheBannersCreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :name
      t.string :slug

      t.string :location
      t.text :html_code, null: false
      t.text :uri, null: false

      t.integer :w
      t.integer :h

      t.integer :view_counter, default: 0
      t.integer :click_counter, default: 0

      t.string :state, default: 'draft', null: false

      t.timestamps
    end
  end
end
