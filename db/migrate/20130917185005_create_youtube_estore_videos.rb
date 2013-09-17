class CreateYoutubeEstoreVideos < ActiveRecord::Migration
  def change
    create_table :youtube_estore_videos do |t|

      t.timestamps
    end
  end
end
