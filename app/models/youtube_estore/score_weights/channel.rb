module YoutubeEstore
  module ChannelScore
  
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