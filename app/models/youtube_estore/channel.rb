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

    def account_slug
      username
    end


    def default_thumbnail_secure
      default_thumbnail.to_s.sub(/^https?:/, '')
    end

    def trending_content(lim=5)
      most_viewed_of_videos(lim)
    end

    def latest_content_date
      videos.order('published_at DESC').pluck('published_at').first
    end

    def link
      "//www.youtube.com/user/#{username}"
    end

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


    ## not tested
    def average_view_count_per_day
      return 0 if account_age_in_days == 0
      view_count / account_age_in_days.to_f
    end


    # aliases for consistency sake
    def view_count_of_videos
      self.view_count
    end

    def count_of_videos
      self.video_count
    end 

############## Aggtive Record based aggregations
#### Needs to be refactored

    # This overrides tweets.rate_per_day_overall
    # DEPRECATED -- we just care about rate_per_month
    def rate_per_day_overall_of_videos
      ( video_count / account_age_in_days.to_f ).round(1)
    end


### TODO: Refactor

    # REFACTOR LATER
    foo_relations = [:videos]

    foo_relations.each do |relation|
      rate_foos = [[:month, :past_year], [:month, :overall]]
      rate_foos.each do |(bucket, span)|
        define_method "rate_per_#{bucket}_#{span}_of_#{relation}" do 
          self.send(relation).send(span).send("rate_per_#{bucket}")
        end
      end

      count_foos = [[:month, :overall]]
      count_foos.each do |(bucket, span)|
        define_method "count_by_#{bucket}_#{span}_of_#{relation}" do 
          self.send(relation).send(span).send("count_by_#{bucket}")
        end
      end
    end



### HISTORY STUFF


    def historical_subscriber_count_past_14_days
      self.archived_attribute('subscriber_count', (14.days.ago))
    end

    def historical_view_count_past_14_days
      self.archived_attribute('view_count', (14.days.ago))
    end

    def historical_rate_per_day_of_subscriber_count_past_14_days
      historical_rate_per_day(:subscriber_count, 14.days.ago)
    end

    def historical_rate_per_day_of_view_count_past_14_days
      historical_rate_per_day(:view_count, 14.days.ago)
    end




#### NOTE: this may all be deprecated

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




private
    # return 0 if self.published_at isn't valid
    def account_age_in_days
      ((Time.now - self.published_at)/(60*60*24)).ceil rescue 0
    end
  end
end






    # def subscriber_count_past_30_days
    #   self.archived_attribute('subscriber_count', (30.days))
    # end

    # def subscriber_count_past_14_days
    #   self.archived_attribute('subscriber_count', (14.days))
    # end



    # def video_count_past_30_days
    #   self.archived_attribute('video_count', (30.days))
    # end

    # def video_count_past_14_days
    #   self.archived_attribute('video_count', (14.days))
    # end



    # def view_count_past_30_days
    #   self.archived_attribute('view_count', (30.days))
    # end

    # def view_count_past_14_days
    #   self.archived_attribute('view_count', (14.days))
    # end

    # def video_rate_per_month
    #   self.videos.rate_per_month(:overall)
    # end