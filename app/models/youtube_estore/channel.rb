module YoutubeEstore
  class Channel < ActiveRecord::Base
    # attr_accessible :title, :body
    has_many :videos, primary_key: :t_id 
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :published_at, :description, :subscriber_count, :video_count, :username, :view_count, :default_thumbnail, :t_id

    DELEGATING_REGEX = /^\w+?(?=(?:_of)?_videos)/

    AGG_REGEX = /^\w+?(?=_with_agg)/
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
      arr = self.all.sort_by { |c| -c.likes_count_of_videos }
      add_sorted_value(arr, 'likes_count_of_videos')
    end
    
    def self.most_approved
      self.all.sort_by { |c| -(c.likes_count_of_videos.to_f / (c.likes_count_of_videos + c.dislikes_count_of_videos))}
    end

    def self.most_viewed
      self.order("view_count DESC")
    end

    def self.most_videos
      arr = self.order("video_count DESC")
      add_sorted_value(arr, 'video_count')
    end



    def self.add_sorted_value(arr, column)
      arr.each do |channel|  
        channel.instance_eval "def sorted_value; #{channel.send(column)}; end"
      end
      arr
    end
   
  end
end
