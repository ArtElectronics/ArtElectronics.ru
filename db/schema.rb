# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151218092517) do

  create_table "archive_numbers", force: true do |t|
    t.string  "cover_file_name"
    t.string  "title"
    t.text    "raw_content"
    t.integer "number"
    t.integer "year"
    t.integer "month"
    t.integer "number_in_year"
  end

  create_table "attached_files", force: true do |t|
    t.integer  "user_id"
    t.integer  "storage_id"
    t.string   "storage_type"
    t.string   "description"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size",    default: 0
    t.datetime "attachment_updated_at"
    t.string   "processing",              default: "none"
    t.boolean  "watermark",               default: false
    t.string   "watermark_text",          default: ""
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: true do |t|
    t.integer  "user_id"
    t.string   "obj_id"
    t.string   "obj_type"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "ip"
    t.string   "remote_ip"
    t.string   "fullpath"
    t.text     "referer"
    t.string   "user_agent"
    t.string   "remote_addr"
    t.string   "remote_host"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "bot",             default: false
  end

  create_table "authors", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "avatar_file_name"
    t.text     "short_description"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_letter",      default: ""
  end

  add_index "authors", ["user_id"], name: "index_authors_on_user_id", using: :btree

  create_table "authorships", force: true do |t|
    t.integer  "post_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["author_id"], name: "index_authorships_on_author_id", using: :btree
  add_index "authorships", ["post_id"], name: "index_authorships_on_post_id", using: :btree

  create_table "banners", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "location"
    t.text     "html_code",                            null: false
    t.text     "uri",                                  null: false
    t.integer  "w"
    t.integer  "h"
    t.integer  "view_counter",       default: 0
    t.integer  "click_counter",      default: 0
    t.string   "state",              default: "draft", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "blogs", force: true do |t|
    t.integer  "user_id"
    t.integer  "hub_id"
    t.string   "title"
    t.text     "raw_intro"
    t.text     "intro"
    t.text     "raw_content",              limit: 16777215
    t.text     "content",                  limit: 16777215
    t.string   "hub_state",                                 default: "draft"
    t.string   "legacy_url"
    t.string   "inline_name_tags",                          default: ""
    t.string   "inline_word_tags",                          default: ""
    t.string   "inline_title_tags",                         default: ""
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                                     default: 0
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size",                      default: 0
    t.datetime "main_image_updated_at"
    t.integer  "show_count",                                default: 0
    t.string   "state",                                     default: "draft"
    t.string   "slug"
    t.string   "short_id"
    t.string   "friendly_id"
    t.integer  "storage_files_count",                       default: 0
    t.integer  "storage_files_size",                        default: 0
    t.integer  "draft_comments_count",                      default: 0
    t.integer  "published_comments_count",                  default: 0
    t.integer  "deleted_comments_count",                    default: 0
    t.string   "comments_switcher",                         default: "on"
    t.boolean  "ugc",                                       default: false
    t.string   "moderation_state",                          default: "unmoderated"
    t.text     "moderator_note"
    t.datetime "moderated_at"
    t.boolean  "yandex_news",                               default: false
    t.boolean  "flipboard_tech",                            default: false
    t.boolean  "flipboard_culture",                         default: false
    t.boolean  "surfingbird",                               default: false
    t.boolean  "novoteka",                                  default: false
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "holder_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "commentable_url"
    t.string   "commentable_title"
    t.string   "commentable_state"
    t.string   "anchor"
    t.string   "title"
    t.string   "contacts"
    t.text     "raw_content"
    t.text     "content"
    t.string   "view_token"
    t.string   "state",             default: "draft"
    t.string   "ip",                default: "undefined"
    t.string   "referer",           default: "undefined"
    t.string   "user_agent",        default: "undefined"
    t.integer  "tolerance_time"
    t.boolean  "spam",              default: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "expires_at"
    t.text     "access_token"
    t.text     "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "hubs", force: true do |t|
    t.integer  "user_id"
    t.integer  "hub_id"
    t.string   "title"
    t.text     "raw_intro"
    t.text     "intro"
    t.text     "raw_content"
    t.text     "content"
    t.string   "hub_state",                default: "draft"
    t.string   "legacy_url"
    t.string   "inline_name_tags",         default: ""
    t.string   "inline_word_tags",         default: ""
    t.string   "inline_title_tags",        default: ""
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pubs_type",                default: "posts"
    t.boolean  "optgroup",                 default: false
    t.integer  "pubs_draft_count",         default: 0
    t.integer  "pubs_published_count",     default: 0
    t.integer  "pubs_deleted_count",       default: 0
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
    t.string   "slug"
    t.string   "short_id"
    t.string   "friendly_id"
    t.integer  "storage_files_count",      default: 0
    t.integer  "storage_files_size",       default: 0
    t.integer  "draft_comments_count",     default: 0
    t.integer  "published_comments_count", default: 0
    t.integer  "deleted_comments_count",   default: 0
  end

  create_table "meta_data", force: true do |t|
    t.integer  "meta_object_id"
    t.integer  "holder_id"
    t.string   "holder_type"
    t.text     "title"
    t.text     "keywords"
    t.text     "description"
    t.text     "author"
    t.text     "og_url"
    t.string   "og_type",        default: ""
    t.text     "og_title"
    t.text     "og_site_name"
    t.text     "og_description"
    t.text     "og_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "user_id"
    t.integer  "hub_id"
    t.string   "title"
    t.text     "raw_intro"
    t.text     "intro"
    t.text     "raw_content"
    t.text     "content"
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
    t.string   "slug"
    t.string   "short_id"
    t.string   "friendly_id"
    t.integer  "storage_files_count",      default: 0
    t.integer  "storage_files_size",       default: 0
    t.integer  "draft_comments_count",     default: 0
    t.integer  "published_comments_count", default: 0
    t.integer  "deleted_comments_count",   default: 0
    t.string   "comments_switcher",        default: "on"
    t.boolean  "ugc",                      default: false
    t.string   "moderation_state",         default: "unmoderated"
    t.text     "moderator_note"
    t.datetime "moderated_at"
    t.boolean  "yandex_news",              default: false
    t.boolean  "flipboard_tech",           default: false
    t.boolean  "flipboard_culture",        default: false
    t.boolean  "surfingbird",              default: false
    t.boolean  "novoteka",                 default: false
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "hub_id"
    t.string   "title"
    t.text     "raw_intro"
    t.text     "intro"
    t.text     "raw_content",              limit: 16777215
    t.text     "content",                  limit: 16777215
    t.string   "hub_state",                                 default: "draft"
    t.string   "legacy_url"
    t.string   "inline_name_tags",                          default: ""
    t.string   "inline_word_tags",                          default: ""
    t.string   "inline_title_tags",                         default: ""
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                                     default: 0
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size",                      default: 0
    t.datetime "main_image_updated_at"
    t.integer  "show_count",                                default: 0
    t.string   "state",                                     default: "draft"
    t.string   "slug"
    t.string   "short_id"
    t.string   "friendly_id"
    t.integer  "storage_files_count",                       default: 0
    t.integer  "storage_files_size",                        default: 0
    t.integer  "draft_comments_count",                      default: 0
    t.integer  "published_comments_count",                  default: 0
    t.integer  "deleted_comments_count",                    default: 0
    t.string   "comments_switcher",                         default: "on"
    t.boolean  "ugc",                                       default: false
    t.string   "moderation_state",                          default: "unmoderated"
    t.text     "moderator_note"
    t.datetime "moderated_at"
    t.boolean  "yandex_news",                               default: false
    t.boolean  "flipboard_tech",                            default: false
    t.boolean  "flipboard_culture",                         default: false
    t.boolean  "surfingbird",                               default: false
    t.boolean  "novoteka",                                  default: false
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.text     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriber_visits", force: true do |t|
    t.string   "email",      default: ""
    t.text     "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: true do |t|
    t.string   "email",              default: ""
    t.string   "state",              default: "unactive"
    t.boolean  "user_send_state",    default: true
    t.string   "confirmation_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree

  create_table "system_messages", force: true do |t|
    t.integer  "user_id"
    t.string   "message_type"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "username",                    default: ""
    t.string   "email",                       default: "",       null: false
    t.string   "encrypted_password",          default: "",       null: false
    t.integer  "role_id"
    t.integer  "show_count",                  default: 0
    t.string   "state",                       default: "active"
    t.integer  "hubs_count",                  default: 0
    t.integer  "posts_count",                 default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "all_attached_files_count",    default: 0
    t.integer  "all_attached_files_size",     default: 0
    t.integer  "storage_files_count",         default: 0
    t.integer  "storage_files_size",          default: 0
    t.integer  "my_draft_comments_count",     default: 0
    t.integer  "my_published_comments_count", default: 0
    t.integer  "my_comments_count",           default: 0
    t.integer  "draft_comcoms_count",         default: 0
    t.integer  "published_comcoms_count",     default: 0
    t.integer  "deleted_comcoms_count",       default: 0
    t.integer  "spam_comcoms_count",          default: 0
    t.integer  "draft_comments_count",        default: 0
    t.integer  "published_comments_count",    default: 0
    t.integer  "deleted_comments_count",      default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "pages_count",                 default: 0
    t.string   "comments_switcher",           default: "on"
    t.text     "raw_about"
    t.text     "about"
    t.string   "vk_addr",                     default: ""
    t.string   "ok_addr",                     default: ""
    t.string   "tw_addr",                     default: ""
    t.string   "fb_addr",                     default: ""
    t.string   "gp_addr",                     default: ""
    t.string   "ig_addr",                     default: ""
    t.string   "pt_addr",                     default: ""
    t.string   "yt_addr",                     default: ""
    t.string   "vm_addr",                     default: ""
    t.string   "sh_addr",                     default: ""
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
