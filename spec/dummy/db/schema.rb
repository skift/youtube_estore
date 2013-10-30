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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131013040014) do

  create_table "content_blobs", :force => true do |t|
    t.integer  "blobable_id"
    t.string   "blobable_type"
    t.text     "contents",      :limit => 2147483647
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "content_blobs", ["blobable_type", "blobable_id"], :name => "index_content_blobs_on_blobable_type_and_blobable_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "youtube_estore_channels", :force => true do |t|
    t.string   "t_id"
    t.datetime "published_at"
    t.string   "description"
    t.integer  "subscriber_count"
    t.integer  "video_count"
    t.string   "username"
    t.string   "title"
    t.integer  "view_count"
    t.string   "default_thumbnail"
    t.datetime "rails_created_at"
    t.datetime "rails_updated_at"
  end

  create_table "youtube_estore_videos", :force => true do |t|
    t.string   "t_id"
    t.integer  "duration_seconds"
    t.string   "category_id"
    t.string   "description"
    t.string   "title"
    t.datetime "published_at"
    t.integer  "view_count"
    t.integer  "favorite_count",    :default => 0
    t.integer  "comment_count"
    t.boolean  "is_embeddable"
    t.integer  "likes",             :default => 0
    t.integer  "dislikes",          :default => 0
    t.float    "approval_rating",   :default => 0.0
    t.string   "channel_id"
    t.string   "default_thumbnail"
    t.datetime "rails_created_at"
    t.datetime "rails_updated_at"
  end

end
