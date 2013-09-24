module YoutubeEstore
  class Channel < ActiveRecord::Base
    # attr_accessible :title, :body
    has_many :videos, primary_key: :t_id 
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :published_at, :description, :subscriber_count, :video_count, :username, :view_count, :default_thumbnail, :t_id

    DELEGATING_REGEX = /^\w+?(?=(?:_of)?_videos)/

    def method_missing(meth, *args, &block)
      if foomatch = meth.to_s.match(DELEGATING_REGEX)
        foo = foomatch.to_s
        videos.send(foo, *args, &block)
      else
        super
      end
    end


    def respond_to?(meth, x=false)
      if meth.match(DELEGATING_REGEX)
        true
      else
        super
      end
    end

    def self.most_liked
      self.all.sort_by { |c| -c.likes_count_of_videos }
      


    end

    def self.most_videos
      self.order("video_count DESC")
    end

    def self.most_viewed
      self.order("view_count DESC")
    end

    def self.most_approved
      self.all.sort_by { |c| -(c.likes_count_of_videos.to_f / (c.likes_count_of_videos + c.dislikes_count_of_videos))}
    end

  end
end
