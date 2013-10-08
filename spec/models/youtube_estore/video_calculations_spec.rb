require 'spec_helper'

module YoutubeEstore
  describe 'calculations' do

    context Video do

      context 'class methods' do 
      
        before(:each) do 
          @video1 = Video.create(t_id: 1, duration_seconds: 10, likes: 10,
                                  dislikes: 40, favorite_count: 6, view_count: 200,
                                  published_at: (60.days.ago))
          @video2 = Video.create(t_id: 2, duration_seconds: 20, likes: 20,
                                  dislikes: 20, favorite_count: 2, view_count: 100,
                                  published_at: (2.days.ago))    
        end

        it '.average_duration should calculate the average duration' do
          expect(Video.average_duration).to eq ((@video1.duration_seconds + @video2.duration_seconds) / 2)
        end

        it '.likes_count should calculate the total number of likes for all videos' do
          expect(Video.likes_count).to eq (@video1.likes + @video2.likes)
        end

        it '.likes_count_past_month should calculate the total number of likes for all videos in the past month' do
          expect(Video.likes_count_past_month).to eq @video2.likes
        end

        it '.dislikes_count should calculate the total number of likes for all videos' do
          expect(Video.dislikes_count).to eq (@video1.dislikes + @video2.dislikes)
        end

        it '.dislikes_count_past_month should calculate the total number of likes for all videos in the past month' do
          expect(Video.dislikes_count_past_month).to eq @video2.dislikes
        end

        it '.favorites_count should calculate the total number of likes for all videos' do
          expect(Video.favorites_count).to eq (@video1.favorite_count + @video2.favorite_count)
        end

        it '.favorites_count_past_month should calculate the total number of likes for all videos in the past month' do
          expect(Video.favorites_count_past_month).to eq @video2.favorite_count
        end

        it '.views_count should calculate the total number of likes for all videos' do
          expect(Video.views_count).to eq (@video1.view_count + @video2.view_count)
        end

        it '.views_count_past_month should calculate the total number of likes for all videos in the past month' do
          expect(Video.views_count_past_month).to eq @video2.view_count
        end

        it '.longest should return the longest video by :duration' do
          expect(Video.longest.first).to eq @video2
        end
      
        it '.most_liked should return 10 videos sorted by :likes' do
          expect(Video.most_liked.first).to eq @video2
        end
      
        it '.most_liked_past_month should return 10 videos sorted by :likes in the past month' do
          expect(Video.most_liked_past_month.first).to eq @video2
        end

        it '.most_disliked should return 10 videos sorted by :dislikes' do
          expect(Video.most_disliked.first).to eq @video1
        end
      
        it '.most_disliked_past_month should return 10 videos sorted by :dislikes in the past month' do
          expect(Video.most_disliked_past_month.first).to eq @video2
        end

        it '.most_viewed should return 10 videos sorted by :most_viewed' do
          expect(Video.most_viewed.first).to eq @video1
        end
      
        it '.most_viewed_past_month should return 10 videos sorted by :most_viewed in the past month' do
          expect(Video.most_viewed_past_month.first).to eq @video2
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
      
        it 'highest_rated_past_month(lim=10)' do
          expect(Video.highest_rated_past_month.first).to eq @video2
        end

        it 'lowest_rated(lim=10)' do
          expect(Video.lowest_rated.first).to eq @video1
        end

        it 'lowest_rated_past_month(lim=10)' do
          expect(Video.lowest_rated_past_month.first).to eq @video2
        end

        it 'limit in .longest works correctly' do
          (3..13).each do |num|
            Video.create(t_id: num, duration_seconds: (num))
          end
          expect(Video.longest.count).to eq 1
          expect(Video.longest(lim=8).count).to eq 8
        end
      end

   

      describe 'time based aggregations' do 

        context 'within :past scope' do 
          it 'should have :highest_rated in :past_month' do 
            @video1 = Video.create(t_id: 1, likes: 20, dislikes: 1, published_at: 1.year.ago )
            @video2 = Video.create(t_id: 2, likes: 1, dislikes: 20, published_at: 1.week.ago )

            expect(Video.highest_rated.past_month.to_a).to eq [@video2]
          end
        end

        describe '#published_count_by_month' do 

          it 'should return a hash count' do 
            Video.create(t_id: 1, published_at: Time.new(2008, 1))
            Video.create(t_id: 2, published_at: Time.new(2008, 1))
            Video.create(t_id: 3, published_at: Time.new(2008, 2))

            expect(Video.count_by_month).to eq(
              {
                Time.new(2008,1,1,0,0,0,0) => 2,
                Time.new(2008,2,1,0,0,0,0) => 1 
              }
            )
          end
        end

      end

      

     context 'instance methods' do 
        before(:each) do 
          @video1 = Video.create(t_id: 1, duration_seconds: 10, likes: 10, dislikes: 40, view_count: 200)
          @video2 = Video.create(t_id: 2, duration_seconds: 20, likes: 20, dislikes: 20, view_count: 100)    
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