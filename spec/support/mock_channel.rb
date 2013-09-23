ActiveRecord::Schema.define do
    create_table :youtube_estore_channels, force: true do |t|
        t.integer   :age
        t.string    :description
        t.integer   :subscriber_count
        t.integer   :video_count
        t.string    :username
        t.integer   :view_count
        t.string    :default_thumbnail
        t.string    :t_id

    end
end