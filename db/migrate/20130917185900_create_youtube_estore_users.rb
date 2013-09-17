class CreateYoutubeEstoreUsers < ActiveRecord::Migration
  def change
    create_table :youtube_estore_users do |t|

      t.timestamps
    end
  end
end
