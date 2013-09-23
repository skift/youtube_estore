require 'aggtive_record'

module YoutubeEstore
  module YoutubeConventions        
    extend ActiveSupport::Concern
    include AggtiveRecord::Aggable



    included do 
      validates_presence_of :t_id
    end


    def timestamp_attributes_for_create
      super << :rails_created_at
    end


    def timestamp_attributes_for_update
      super << :rails_updated_at
    end



  end
end