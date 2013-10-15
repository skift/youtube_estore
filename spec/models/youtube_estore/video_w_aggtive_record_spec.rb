require 'spec_helper'

module YoutubeEstore
  describe 'AggtiveRecord dependency' do

    context ':past scope' do 
      it 'should have videos past 14 days' do 
        Video.create(t_id: 1, published_at: 16.days.ago)
        @v = Video.create(t_id: 2, published_at: 13.days.ago)

        expect(Video.past_14_days.to_a).to eq [@v]
      end
    end


    context ':count_by scope' do 
      it 'should have :count_by aggregation' do 
        @v1 = Video.create(t_id: 1, published_at: '2009-02-01')
        @v2 = Video.create(t_id: 2, published_at: '2011-02-01')
              Video.create(t_id: 3, published_at: '2011-05-01')

          # need to refactor this
        expect(Video.count_by(:year).select{|k,v| k.year == 2011}.first[1] ).to eq 2

      end


      it 'should have :rate_by aggregation' do 
        @channel = Channel.create(t_id: 1)
       
        expect(@channel.videos.rate_per_year(:overall)).to eq 0
      end



    end
  end
end