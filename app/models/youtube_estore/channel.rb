module YoutubeEstore
  class Channel < ActiveRecord::Base
    # attr_accessible :title, :body
    has_many :videos, primary_key: :t_id 
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :t_id, :video_count

    # alias_method :number_of_subscribers, :subscriber_count
    # alias_method :number_of_video_views, :upload_views
    # alias_method :number_of_uploads, :video_count

    # alias_method :subscriber_count, :number_of_subscribers
    # alias_method :upload_views, :number_of_video_views
    # alias_method :video_count, :number_of_uploads

  end
end
