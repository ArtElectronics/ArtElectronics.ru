class UpTagsMigration < ActiveRecord::Migration
  def change
    add_column :tags, :taggings_count, :integer, default: 0

    ActsAsTaggableOn::Tag.reset_column_information

    # ActsAsTaggableOn::Tag.find_each do |tag|
    #   ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    # end

    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
