class CreateMetaData < ActiveRecord::Migration
  def change
    create_table :meta_data do |t|
      t.references :meta_object
      t.references :holder, polymorphic: true

      t.string :title,    default: ''
      t.string :keywords, default: ''
      t.text   :description
      t.string :author, default: ''

      t.string :og_url,       default: ''
      t.string :og_type,      default: ''
      t.string :og_title,     default: ''
      t.string :og_site_name, default: ''
      t.text   :og_description
      t.text   :og_image

      t.timestamps
    end
  end
end
