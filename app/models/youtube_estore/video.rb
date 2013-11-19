require 'estore_conventions'
require 'active_record_content_blob'

module YoutubeEstore
  class Video < ActiveRecord::Base
    include EstoreConventions
    include ActiveRecordContentBlob::Blobable
    

    attr_datetime :published_at

    before_save :calculate_approval_rating

    belongs_to :channel, primary_key: :t_id

    attr_accessible :duration_seconds, :category_id, :description, :title, :published_at, :view_count, :favorite_count, :is_embeddable, :likes, :dislikes, :approval_rating, :t_id, 
      :channel_id, :username, :default_thumbnail, :category_id, :comment_count

    def link
      "//www.youtube.com/watch?v=#{t_id}"
    end

    def thumbnail
      self.default_thumbnail.gsub('default', 'hqdefault')
    end

    def thumbnail_secure
      thumbnail.sub(/^https?:/, '')
    end

    # may be deprecated
    def default_thumbnail_secure
      default_thumbnail.sub(/^https?:/, '')
    end

    def source_link
      "//www.youtube.com/videos/#{t_id}"
    end

################### Class Methods #######################


    # returns float
    def self.overall_approval_rating  # channel.overall_approval_rating_of_videos
      v = (self.sum(:likes) + self.sum(:dislikes)).to_f

      if v == 0
        return 0
      else
        self.sum(:likes) / v
      end
    end



    def self.likes_count
      self.sum(:likes)
    end

    def self.likes_count_past_month
      self.past_month.sum(:likes)
    end

    def self.dislikes_count
      self.sum(:dislikes)
    end

    def self.dislikes_count_past_month
      self.past_month.sum(:dislikes)
    end

    def self.favorites_count
      self.sum(:favorite_count)
    end

    def self.favorites_count_past_month
      self.past_month.sum(:favorite_count)
    end

    def self.views_count
      self.sum(:view_count)
    end

    def self.views_count_past_month
      self.past_month.sum(:view_count)
    end



   # returns integer
    def self.average_duration   # channel.     average_duration   _of_videos
       self.average(:duration_seconds).to_i
    end

    # untested, separate from self.longest
    # returns seconds(Integer)
    def self.longest_duration
      if v = self.longest
        return v.duration_seconds
      end
    end


    # returns single video, untested
    def self.least_approved
      self.enough_views.order('approval_rating ASC').first
    end

    # returns single video, untested
    def self.most_approved
      self.enough_views.order('approval_rating DESC').first
    end

    # returns Hash of keys, from 0 to 100, with values of videos by approval rating

    def self.approval_rating_distribution
      self.enough_views.group('CAST( ROUND(approval_rating * 100) AS UNSIGNED )').count
    end

    # untested
    scope :enough_views, where('view_count > 5000')
    scope :enough_ratings, where('likes + dislikes > 10')
#    scope :enough_evaluations, ->(){ enough_views.enough_ratings }

    # untested, just returns one
    def self.longest
      self.order('duration_seconds DESC').first
    end

    # untested, just returns one
    def self.shortest
      self.order('duration_seconds ASC').first
    end
    
    # untested, seperate from self.most_viewed
    # returns number of views
    def self.highest_view_count
      if v = highest_viewed
        return v.view_count
      end
    end

    # untested, different implementation than most_viewed
    def self.highest_viewed
      self.order('view_count DESC').first
    end

    # untested, returns Integer
    def self.average_view_count
      average(:view_count).to_i
    end



    # deprecated
    # def self.longest(lim=1) # longest_videos
    #   add_sorted_value_and_sort('duration_seconds', {limit: lim})
    # end

    def self.most_liked(lim=10)
      add_sorted_value_and_sort('likes', {limit: lim})
    end

    def self.most_liked_past_month(lim=10)
      self.past_month.most_liked(lim)
    end

    def self.most_disliked(lim=10)
      add_sorted_value_and_sort('dislikes', {limit: lim})
    end

    def self.most_disliked_past_month(lim=10)
      self.past_month.most_disliked(lim)
    end

    def self.most_viewed(lim=10)
      add_sorted_value_and_sort('view_count', {limit: lim})
    end

    def self.most_viewed_past_month(lim=10)
      self.past_month.most_viewed(lim)
    end

    def self.highest_rated(lim=10)
      add_sorted_value_and_sort('approval_rating', {limit: lim})
    end

    def self.highest_rated_past_month(lim=10)
      self.past_month.highest_rated(lim)
    end

    def self.lowest_rated(lim=10)
      add_sorted_value_and_sort('approval_rating', {order: 'ASC', limit: lim})
    end

    def self.lowest_rated_past_month(lim=10)
      self.past_month.lowest_rated(lim)
    end



    def self.convert_iso8601_to_seconds(string)
      if mtch = string.match(/^PT(?:(\d*)M)?(?:(\d*)S)?$/)
        min, sec = mtch[1..2]
        
        total = min.to_i*60 + sec.to_i
      end
    end











    private

    def calculate_approval_rating
      total = (self.likes + self.dislikes).to_f
      if total == 0
        self.approval_rating = 0
      else
        self.approval_rating = self.likes / total
      end
    end


  end
end
