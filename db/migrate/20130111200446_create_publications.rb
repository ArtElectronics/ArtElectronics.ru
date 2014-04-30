class CreatePublications < ActiveRecord::Migration
  def change
    [:pages, :posts, :hubs].each do |table_name|
      create_table table_name do |t|
        t.integer :user_id
        t.integer :hub_id

        # Meta
        t.string :author
        t.string :keywords
        t.string :description
        t.string :copyright
        
        # Base
        t.string :title
        
        t.text   :raw_intro
        t.text   :intro

        t.text   :raw_content
        t.text   :content

        # denormalization
        t.string :hub_state,  default: :draft
        t.string :legacy_url

        t.string :inline_name_tags, default: ''
        t.string :inline_word_tags, default: ''
        t.string :inline_title_tags,default: ''

        # DateTime
        t.datetime :published_at
        t.timestamps
      end
    end
  end
end