require 'estore_conventions'
require 'paper_trail'

module YoutubeEstore
  class Channel < ActiveRecord::Base
    include EstoreConventions
    include Blobable

    
    attr_datetime :published_at
    has_paper_trail

    has_many :videos, primary_key: :t_id

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




ZERO_TO_FOUR = { 
        "...1" =>  0,
        1...2 => 25,
        2...3 => 50,
        3...4 => 75,
        "4.." => 100
      }

ZERO_TO_TEN = { 
        "...1" =>  0,
        1...3 => 25,
        3...6 => 50,
        6...10 => 75,
        "10.." => 100
      }

ZERO_TO_TWENTY_FIVE = { 
        "...1" =>  0,
        1...3 => 25,
        3...10 => 50,
        10...25 => 75,
        "25.." => 100
      }

ZERO_TO_TEN_THOUSAND = { 
        "..99" =>  0,
        100..499 => 25,
        500..999 => 50,
        1000..9999 => 75,
        "10000.." => 100
      }

ZERO_TO_ONE_MILLION = { 
        "..99" =>  0,
        100..999 => 25,
        1000..99999 => 50,
        100000..999999 => 75,
        "1000000.." => 100
      }

ZERO_TO_TEN_MILLION = { 
        "..999" =>  0,
        1000..9999 => 25,
        10000..999999 => 50,
        1000000..9999999 => 75,
        "10000000.." => 100
      }

TWO_TO_ZERO = { 
        "...0.25" => 100,
        0.25...0.50 => 75,
        0.50...1 => 50,
        1...2 => 25,
        "2.." => 0
      }

SEVEN_TO_ZERO = { 
        "...1" => 100,
        1...2 => 75,
        2...4 => 50,
        4...7 => 25,
        "7.." => 0
      }

TIMES_ONE_HUNDRED = Proc.new { |num|  num * 100 }

# replace this once we have ranking enabled
RANKING = Proc.new { |num|  num * 0 }

BOOLEAN = {
        false =>  0,
        true => 100
      }


SCORE_WEIGHTS = { 

  :subscriber_count => {
      weight: 0.20,
      thresholds: ZERO_TO_TEN_THOUSAND
  }, 

  :view_count => {
      weight: 0.25,
      thresholds:  ZERO_TO_TEN_MILLION
  },

  # :video_count_per_month => {
  #     weight: 0.05,
  #     thresholds:  ZERO_TO_FOUR
  # },

  :overall_approval_rating_of_videos => {
    weight: 0.25, 
    thresholds: TIMES_ONE_HUNDRED
  }

}



  end
end
