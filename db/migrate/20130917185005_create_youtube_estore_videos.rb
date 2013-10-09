class CreateYoutubeEstoreVideos < ActiveRecord::Migration
  def change
    create_table :youtube_estore_videos, force: true do |t|
      t.integer  "duration_seconds"
      t.string   "category_id"
      t.string   "description"
      t.string   "username"
      t.string   "title"
      t.datetime "published_at"
      t.integer  "view_count"
      t.integer  "favorite_count",   :default => 0
      t.integer  "comment_count"
      t.boolean  "is_embeddable"
      t.integer  "likes",            :default => 0
      t.integer  "dislikes",         :default => 0
      t.float    "approval_rating",  :default => 0.0
      t.string   "t_id"
      t.string   "channel_id"
      t.string   "default_thumbnail"
      t.datetime "rails_created_at"
      t.datetime "rails_updated_at"

    end
  end
end
