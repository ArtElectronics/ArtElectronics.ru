class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.integer  "user_id"
      t.integer  "hub_id"
      t.string   "title"
      t.text     "raw_intro"
      t.text     "intro"
      t.text     "raw_content",              limit: 16777215
      t.text     "content",                  limit: 16777215
      t.string   "hub_state",                default: "draft"
      t.string   "legacy_url"
      t.string   "inline_name_tags",         default: ""
      t.string   "inline_word_tags",         default: ""
      t.string   "inline_title_tags",        default: ""
      t.datetime "published_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth",                    default: 0
      t.string   "main_image_file_name"
      t.string   "main_image_content_type"
      t.integer  "main_image_file_size",     default: 0
      t.datetime "main_image_updated_at"
      t.integer  "show_count",               default: 0
      t.string   "state",                    default: "draft"
      t.string   "moderation_state",         default: "raw"
      t.text     "moderator_note"
      t.string   "slug"
      t.string   "short_id"
      t.string   "friendly_id"
      t.integer  "storage_files_count",      default: 0
      t.integer  "storage_files_size",       default: 0
      t.integer  "draft_comments_count",     default: 0
      t.integer  "published_comments_count", default: 0
      t.integer  "deleted_comments_count",   default: 0
      t.string   "comments_switcher",        default: "on"
    end
  end
end
