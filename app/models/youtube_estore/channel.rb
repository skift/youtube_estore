require 'estore_conventions'
require 'active_record_content_blob'

module YoutubeEstore
  class Channel < ActiveRecord::Base
    include EstoreConventions
    include ActiveRecordContentBlob::Blobable
    
    attr_datetime :published_at
    has_paper_trail

    has_many :videos, primary_key: :t_id

    attr_accessible :published_at, :description, :subscriber_count,
     :video_count, :username, :view_count, :default_thumbnail, :title, 
     :t_id


    # converts a t_id of this: UCFXno2GGPrAW-XU0pOc4QoA
    # to: UUFXno2GGPrAW-XU0pOc4QoA
    def default_upload_playlist
      if t_id.match(/^UC/)
        t_id.sub(/^UC/, 'UU')
      else
        nil
      end
    end


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
      proc = Proc.new{|c| c.likes_count_of_videos}
      add_sorted_value_and_sort(proc)
    end
    
    def self.most_liked_past_month
      proc = Proc.new{|c| c.likes_count_past_month_of_videos}
      add_sorted_value_and_sort(proc)
    end

    def self.most_approved
      proc = Proc.new{|c| (c.likes_count_of_videos.to_f / (c.likes_count_of_videos + c.dislikes_count_of_videos)) }
      add_sorted_value_and_sort(proc)
    end

    def self.most_approved_past_month
      proc = Proc.new{|c|         
        t =  (c.likes_count_past_month_of_videos + c.dislikes_count_past_month_of_videos)
        if t == 0
          0
        else
          c.likes_count_past_month_of_videos.to_f / t
        end
      }
      add_sorted_value_and_sort(proc)
    end

    def self.most_viewed
      add_sorted_value_and_sort('view_count')
    end

    def self.most_viewed_past_month
      proc = Proc.new{|c| c.views_count_past_month_of_videos}
      add_sorted_value_and_sort(proc)
    end

    def self.most_videos
      add_sorted_value_and_sort('video_count')
    end

    def self.most_videos_past_month
      add_sorted_value_and_sort('video_count')
    end


    def subscriber_count_past_30_days
      self.archived_attribute('subscriber_count', (30.days))
    end

    def subscriber_count_past_14_days
      self.archived_attribute('subscriber_count', (14.days))
    end



    def video_count_past_30_days
      self.archived_attribute('video_count', (30.days))
    end

    def video_count_past_14_days
      self.archived_attribute('video_count', (14.days))
    end



    def view_count_past_30_days
      self.archived_attribute('view_count', (30.days))
    end

    def view_count_past_14_days
      self.archived_attribute('view_count', (14.days))
    end

    def video_rate_per_month
      self.videos.rate_per_month(:overall)
    end


  end
end
