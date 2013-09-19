require 'spec_helper'

module YoutubeEstore
  describe 'calculations' do

    context Video do 

      it 'should be have an average duration within any scope' do
        Video.create(t_id: 1, duration: 2, likes: 100, dislikes: 200)
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

      it 'should be have a maximum duration of 20' do
        pending 'write this test'
      end

      it 'average_duration' do
        pending 'write this test'
      end
      
      it 'maximum_duration' do
        pending 'write this test'
      end
    
      it 'most_liked(lim=10)' do
        pending 'write this test'
      end
    
      it 'most_unliked(lim=10)' do
        pending 'write this test'
      end
    
      it 'most_views(lim=10)' do
        pending 'write this test'
      end
    
      it 'average_rating_of_videos' do
        pending 'write this test'
      end
    
      it 'videos_with_highest_average_rating(lim=10)' do
        pending 'write this test'
      end
    
      it 'videos_with_lowest_average_rating(lim=10)' do
        pending 'write this test'
      end
    
      it 'calculate_average_rating' do
        pending 'write this test'
      end



















    end

    context Channel do 
      describe 'column based metrics' do 
        it 'should get video_count from :video_count' do 
          @channel = Channel.create(t_id: 3, video_count: 20)  

          expect(@channel.video_count).to eq @channel.read_attribute( :video_count   )

          expect(@channel.video_count).not_to eq @channel.videos.count   
        end


      end
    end
  

  end


end