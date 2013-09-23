module YoutubeEstore
  class Video < ActiveRecord::Base
    include YoutubeConventions
    attr_datetime :published_at

    before_save :calculate_approval_rating

    belongs_to :channel, primary_key: :t_id
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :t_id, :duration, :likes, :dislikes, :view_count




################### Class Methods #######################

   # returns integer
    def self.average_duration   # channel.     average_duration   _of_videos
       self.average(:duration)
    end

    # returns float
    def self.overall_approval_rating  # channel.overall_approval_rating_of_videos
      self.sum(:likes).to_f / (self.sum(:likes) + self.sum(:dislikes))
    end




    def self.longest(lim=1) # longest_videos
      self.order("duration DESC").limit(lim)
    end

    def self.most_liked(lim=10)
      self.order("likes DESC").limit(lim)
    end

    def self.most_disliked(lim=10)
      self.order("dislikes DESC").limit(lim)
    end

    def self.most_viewed(lim=10)
      self.order("view_count DESC").limit(lim)
    end


    def self.highest_rated(lim=10)
      self.order("approval_rating DESC").limit(lim)
    end

    def self.lowest_rated(lim=10)
      self.order("approval_rating ASC").limit(lim)
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
