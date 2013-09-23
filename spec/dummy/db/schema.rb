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

ActiveRecord::Schema.define(:version => 20130917185900) do

  create_table "youtube_estore_channels", :force => true do |t|
    t.integer "age"
    t.string  "description"
    t.integer "subscriber_count"
    t.integer "video_count"
    t.string  "username"
    t.integer "view_count"
    t.string  "default_thumbnail"
    t.string  "t_id"
  end

  create_table "youtube_estore_videos", :force => true do |t|
    t.integer  "duration"
    t.string   "racy"
    t.string   "widescreen"
    t.string   "video_id"
    t.string   "categories"
    t.string   "description"
    t.string   "title"
    t.string   "author_name"
    t.datetime "published_at"
    t.datetime "updated_at"
    t.integer  "view_count"
    t.integer  "favorite_count"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "unique_id"
    t.boolean  "is_embeddable"
    t.integer  "likes",            :default => 0
    t.integer  "dislikes",         :default => 0
    t.float    "approval_rating",  :default => 0.0
    t.string   "t_id"
    t.string   "channel_id"
    t.datetime "rails_created_at"
    t.datetime "rails_updated_at"
  end

end
