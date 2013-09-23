require 'spec_helper'

module YoutubeEstore
  describe 'calculations' do

    context Video do

      context 'class methods' do 
      
        before(:each) do 
          @video1 = Video.create(t_id: 1, duration: 10, likes: 10, dislikes: 40, view_count: 200)
          @video2 = Video.create(t_id: 2, duration: 20, likes: 20, dislikes: 20, view_count: 100)    
        end

        it '.average_duration should calculate the average duration' do
          expect(Video.average_duration).to eq ((@video1.duration + @video2.duration) / 2)
        end

        it '.longest should return the longest video by :duration' do
          expect(Video.longest.first).to eq @video2
        end
      
        it '.most_liked should return 10 videos sorted by :likes' do
          expect(Video.most_liked.first).to eq @video2
        end
      
        it '.most_disliked should return 10 videos sorted by :dislikes' do
          expect(Video.most_disliked.first).to eq @video1
        end
      
        it '.most_viewed should return 10 videos sorted by :most_viewed' do
          expect(Video.most_viewed.first).to eq @video1
        end
      
        it '.overall_approval_rating should calculate the average rating' do
          likes = Video.sum(:likes)
          dislikes = Video.sum(:dislikes)
          total = (likes + dislikes).to_f

          expect(Video.overall_approval_rating).to eq likes/total
        end
      
        it 'highest_rated(lim=10)' do
          expect(Video.highest_rated.first).to eq @video2
        end
      
        it 'lowest_rated(lim=10)' do
          expect(Video.lowest_rated.first).to eq @video1
        end
      end

   

      context 'within :past scope' do 
        it 'should have :highest_rated in :past_month' do 
          @video1 = Video.create(t_id: 1, likes: 20, dislikes: 1, published_at: 1.year.ago )
          @video2 = Video.create(t_id: 2, likes: 1, dislikes: 20, published_at: 1.week.ago )

          expect(Video.highest_rated.past_month.to_a).to eq [@video2]
        end
      end

     context 'instance methods' do 
      
        before(:each) do 
          @video1 = Video.create(t_id: 1, duration: 10, likes: 10, dislikes: 40, view_count: 200)
          @video2 = Video.create(t_id: 2, duration: 20, likes: 20, dislikes: 20, view_count: 100)    
        end

        it 'calculates :approval_rating upon saving' do
          @video = Video.new(t_id: 11, likes: 10, dislikes: 90)
          expect(@video.approval_rating).to eq 0
          @video.save
          expect(@video.approval_rating).to eq 0.1
        end
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