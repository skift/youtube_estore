module YoutubeEstore
  class Video < ActiveRecord::Base
    before_save :calculate_average_rating

    belongs_to :channel, primary_key: :t_id
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :t_id, :duration


################### Class Methods #######################

    def self.average_duration
       self.average(:duration)
    end

    def self.maximum_duration
      self.maximum(:duration)
    end

    def self.most_liked(lim=10)
      self.maximum(:likes).limit(lim)
      # pending "come back to this - clearly this isn't enough"
    end

    def self.most_unliked(lim=10)
      self.maximum(:dislikes).limit(lim)
      # pending "come back to this - clearly this isn't enough"
    end

    def self.most_views(lim=10)
      self.maximum(:view_count).limit(lim)
    end

    def self.average_rating_of_videos
      self.sum(:likes) / (self.sum(:likes) + self.sum(:dislikes))
    end

    def self.videos_with_highest_average_rating(lim=10)
      self.maximum(:average_rating).limit(lim)
    end

    def self.videos_with_lowest_average_rating(lim=10)
      self.minimum(:average_rating).limit(lim)
    end


    private

    def calculate_average_rating
      total = (self.likes + self.dislikes).to_f
      if total == 0
        self.average_rating = 0
      else
        self.average_rating = self.likes / total
      end
    end




  end
end
