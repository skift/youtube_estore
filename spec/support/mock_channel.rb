ActiveRecord::Schema.define do
    create_table :youtube_estore_channels do |t|
        t.integer   :age
        t.string    :company
        t.string    :description
        t.string    :last_login
        t.string    :location
        t.datetime  :join_date
        t.integer   :subscriber_count
        t.integer   :upload_views
        t.integer   :video_count      
        t.string    :username
#        t.integer   :view_count
        t.string    :avatar
        t.string    :t_id

    end
end