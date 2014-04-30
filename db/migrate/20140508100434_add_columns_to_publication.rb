class AddColumnsToPublication < ActiveRecord::Migration
  def change
    [:pages, :posts, :hubs].each do |t|
      # denormalization
      add_column t, :inline_name_tags, :string, default: ''
      add_column t, :inline_word_tags, :string, default: ''
      add_column t, :inline_title_tags,:string, default: ''
    end
  end
end
