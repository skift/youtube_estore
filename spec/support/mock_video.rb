ActiveRecord::Schema.define do
  create_table :youtube_estore_videos do |t|
    t.integer   :duration
    t.string    :racy
    t.string    :widescreen 
    t.string    :video_id
    t.string    :categories
    t.string    :description
    t.string    :title
    t.string    :author_name
    
    t.datetime  :published_at
    t.datetime  :updated_at

    t.datetime  :rails_created_at
    t.datetime  :rails_updated_at

    t.integer   :view_count
    t.integer   :favorite_count
    t.float     :latitude
    t.float     :longitude
    t.string    :unique_id
    t.boolean   :is_embeddable  
    t.float     :average_rating
    t.integer   :likes
    t.integer   :dislikes
    t.integer   :rater_count
  end
end

