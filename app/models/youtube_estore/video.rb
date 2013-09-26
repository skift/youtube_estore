module YoutubeEstore
  class Video < ActiveRecord::Base
    include YoutubeConventions
    attr_datetime :published_at

    before_save :calculate_approval_rating

    belongs_to :channel, primary_key: :t_id

    attr_accessible :duration_seconds, :category_id, :description, :title, :published_at, :view_count, :favorite_count, :is_embeddable, :likes, :dislikes, :approval_rating, :t_id, :channel_id, :username, :default_thumbnail, :category_id, :comment_count


################### Class Methods #######################

   # returns integer
    def self.average_duration   # channel.     average_duration   _of_videos
       self.average(:duration_seconds)
    end

    # returns float
    def self.overall_approval_rating  # channel.overall_approval_rating_of_videos
      self.sum(:likes).to_f / (self.sum(:likes) + self.sum(:dislikes))
    end


    def self.likes_count
      self.sum(:likes)
    end

    def self.dislikes_count
      self.sum(:dislikes)
    end

    def self.favorites_count
      self.sum(:favorite_count)
    end



    def self.longest(lim=1) # longest_videos
      add_sorted_value_and_sort('duration_seconds', {limit: lim})
    end

    def self.most_liked(lim=10)
      add_sorted_value_and_sort('likes', {limit: lim})
    end

    def self.most_disliked(lim=10)
      add_sorted_value_and_sort('dislikes', {limit: lim})
    end

    def self.most_viewed(lim=10)
      add_sorted_value_and_sort('view_count', {limit: lim})
    end

    def self.highest_rated(lim=10)
      add_sorted_value_and_sort('approval_rating', {limit: lim})
    end

    def self.lowest_rated(lim=10)
      add_sorted_value_and_sort('approval_rating', {order: 'ASC', limit: lim})
    end



    def self.convert_iso8601_to_seconds(string)
      min, sec = string.match(/^PT(\d*)M(\d*)S$/)[1..2]
      total = min.to_i*60 + sec.to_i
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
