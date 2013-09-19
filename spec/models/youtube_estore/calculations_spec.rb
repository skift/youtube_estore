require 'spec_helper'

module YoutubeEstore
  describe 'calculations' do

    context Video do 

      it 'should be have an average duration within any scope' do
        Video.create(t_id: 1, duration: 2)
        Video.create(t_id: 11, duration: 2)
        Video.create(t_id: 2, duration: 10)
        Video.create(t_id: 3, duration: 20)

        expect(Video.where('duration > 5').average_duration).to eq 15
      end

      it 'should be have a maximum duration of 20' do
        Video.create(t_id: 1, duration: 2)
        Video.create(t_id: 11, duration: 2)
        Video.create(t_id: 2, duration: 10)
        Video.create(t_id: 3, duration: 20)
     
        expect(Video.where('duration > 5').maximum_duration).to eq 20
      end
    end

    context Channel do 
      describe 'column based metrics' do 
        it 'should get videos_count from :videos_count' do 
          @channel = Channel.create(t_id: 3, videos_count: 20)  

          expect(@channel.videos_count).to eq @channel.read_attribute( :videos_count   )

          expect(@channel.videos_count).not_to eq @channel.videos.count   
        end


      end
    end
  

  end


end