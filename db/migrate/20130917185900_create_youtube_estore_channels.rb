class CreateYoutubeEstoreChannels < ActiveRecord::Migration
  def change
    create_table :youtube_estore_channels, force: true do |t|
        t.datetime  :published_at
        t.string    :description
        t.integer   :subscriber_count
        t.integer   :video_count
        t.string    :username
        t.string    :title
        t.integer   :view_count
        t.string    :default_thumbnail
        t.string    :t_id
        t.datetime "rails_created_at"
        t.datetime "rails_updated_at"
    end
  end
end
