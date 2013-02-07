# This migration comes from the_comments_engine (originally 20130101010101)
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      # relations
      t.integer :user_id
      
      # polymorphic, commentable obj
      t.integer :commentable_id
      t.string  :commentable_type

      # comment
      t.string :title,    null: false
      t.string :contacts, null: false

      t.text :raw_content, null: false
      t.text :content,     null: false

      # state machine => :not_approved | :approved | deleted
      t.string :state, default: :not_approved

      # base user data (BanHammer power)
      t.string :ip
      t.string :referer
      t.string :user_agent

      # nested set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, default: 0

      t.timestamps
    end

    # Add fields to User and Commentable Object
    change_table :users do |t|
      t.integer :total_comments_count, default: 0
      t.integer :new_comments_count,   default: 0
    end

    [:users, :pages, :posts, :articles, :recipes, :blogs, :notes].each do |table_name|
      change_table table_name do |t|
        t.integer :comments_count, default: 0
      end
    end
  end
end