class CreateYoutubeEstoreChannels < ActiveRecord::Migration
  def change
    create_table :youtube_estore_channels do |t|

      t.timestamps
    end
  end
end
