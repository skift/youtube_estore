ActiveRecord::Schema.define do
    create_table :youtube_estore_users do |t|
        t.integer   :age 
        t.string    :company 
        t.string    :description 
        t.string    :last_login 
        t.string    :location 
        t.datetime  :join_date 
        t.integer   :subscribers 
        t.integer   :upload_views 
        t.string    :username 
        t.integer   :videos_watched 
        t.integer   :view_count 
        t.string    :avatar 

    end
end