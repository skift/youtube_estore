require 'spec_helper'

module YoutubeEstore
  describe Channel do

    it 'should have many videos' do 
      @video1 = Video.create(t_id: 1)
      @video2 = Video.create(t_id: 2)
      @channel = Channel.create(t_id: 1)

      @channel.videos << @video1
      @channel.videos << @video2
      
      expect(@channel.videos.count).to eq 2
    end

    context 'channel calculations' do
      before(:each) do 
        @video1 = Video.create(t_id: 1, duration_seconds: 10, likes: 10, dislikes: 90, favorite_count: 6, view_count: 200)
        @video2 = Video.create(t_id: 2, duration_seconds: 20, likes: 20, dislikes: 80, favorite_count: 2, view_count: 100)    
        @video3 = Video.create(t_id: 3, duration_seconds: 10, likes: 30, dislikes: 70, favorite_count: 6, view_count: 200)
        @video4 = Video.create(t_id: 4, duration_seconds: 20, likes: 40, dislikes: 60, favorite_count: 2, view_count: 100)    
        @video5 = Video.create(t_id: 5, duration_seconds: 10, likes: 5, dislikes: 95, favorite_count: 6, view_count: 200)
        @video6 = Video.create(t_id: 6, duration_seconds: 20, likes: 6, dislikes: 94, favorite_count: 2, view_count: 100)    
        @video7 = Video.create(t_id: 7)
        @video8 = Video.create(t_id: 8)
        @video9 = Video.create(t_id: 9)
        @channel1 = Channel.create(t_id: 1, video_count: 3, view_count: 300)
        @channel2 = Channel.create(t_id: 2, video_count: 2, view_count: 400)
        @channel3 = Channel.create(t_id: 3, video_count: 4, view_count: 500)

        @channel1.videos << @video1
        @channel1.videos << @video2
        @channel2.videos << @video3
        @channel2.videos << @video4
        @channel3.videos << @video5
        @channel3.videos << @video6
        @channel1.videos << @video7
        @channel3.videos << @video8
        @channel3.videos << @video9
      end

      context 'aggregations based on :videos relation' do 
        it '.most_liked should do it' do      
          expect(Channel.most_liked.to_a).to eq [@channel2, @channel1, @channel3]
        end

        it '.most_videos should do it' do      
          expect(Channel.most_videos.to_a).to eq [@channel3, @channel1, @channel2]
        end

        it '.most_approved should do it' do      
          expect(Channel.most_approved.to_a).to eq [@channel2, @channel1, @channel3]
        end
      end


      context 'aggregations based on Channel attributes' do 
        it '.most_viewed should do it' do      
          expect(Channel.most_viewed.to_a).to eq [@channel3, @channel2, @channel1]
        end
      end

       

      describe 'with_count meta programming' do 

        it ':most_liked should have :sorted_value set' do 
          arr = Channel.most_liked
          channel = arr.find{|a| a.t_id == @channel2.t_id.to_s }
          expect(channel.t_id).to eq @channel2.t_id.to_s
          expect(channel.sorted_value).to eq 70
        end

        it ':most_videos should have :sorted_value set' do 
          arr = Channel.most_videos
          channel = arr.first

          expect(channel).to eq @channel3
          expect(channel.sorted_value).to eq @channel3.video_count
        end

      end



    end

    context 't_id' do 
      it 'should be valid with simply a t_id' do
        @channel = YoutubeEstore::Channel.new(t_id: 1)
        @channel.save!
        expect(@channel.valid?).to be_true  
        expect(@channel.t_id).to eq 1
        expect(Channel.count).to eq 1
      end

      it 'should not validate with no t_id' do 
        @channel = YoutubeEstore::Channel.new(t_id: nil)
        expect(@channel.valid?).not_to be_true
      end
    end


    context 'past month video calculations' do 
       before(:each) do 
          @channel1 = YoutubeEstore::Channel.create(t_id: 1)
          @channel2 = YoutubeEstore::Channel.create(t_id: 2)
          @channel1.videos << @video1 = Video.create(t_id: 1, duration_seconds: 10, likes: 10, dislikes: 40, view_count: 200, published_at: (2.days.ago))
          @channel2.videos << @video2 = Video.create(t_id: 2, duration_seconds: 20, likes: 20, dislikes: 20, view_count: 100, published_at: (100.days.ago))    
        end

        it '.most_liked_past_month should do it' do      
          expect(Channel.most_liked_past_month).to eq [@channel1, @channel2]
        end

        it '.most_approved_past_month should do it' do 
          expect(Channel.most_approved_past_month).to eq [@channel1, @channel2]
        end

        it '.most_viewed_past_month should do it' do      
          expect(Channel.most_viewed_past_month).to eq [@channel1, @channel2]
        end

        it '.most_videos_past_month should do it' do      
          expect(Channel.most_videos_past_month).to eq [@channel1, @channel2]
        end

      end




    context 'delegation to videos' do 
       before(:each) do 
          @channel = YoutubeEstore::Channel.create(t_id: 1)
          @channel.videos << @video1 = Video.create(t_id: 1, duration_seconds: 10, likes: 10, dislikes: 40, view_count: 200)
          @channel.videos << @video2 = Video.create(t_id: 2, duration_seconds: 20, likes: 20, dislikes: 20, view_count: 100)    
        end


        describe '#longest_videos' do 
          it 'returns n videos by duration' do 
            expect(@channel.longest_videos(2)).to eq [@video2, @video1]
          end
        end

        describe '#likes_count_of_videos' do 
          it 'returns sum of likes_count of videos' do 
            expect(@channel.likes_count_of_videos).to eq (@video1.likes + @video2.likes)
          end
        end

    end




    context 'channel version convienece methods' do
      before(:each) do
        @channel = Channel.create t_id: '1'
        50.times do |n|
          Timecop.travel(n.days.ago)
          @channel.subscriber_count = n
          @channel.video_count = n*2
          @channel.view_count = n*10
          @channel.save
          Timecop.return
        end
      end


      it '.subscriber_count_past_30_days', :versioning => true do
        hsh = {}
        30.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n
        end

        expect(@channel.subscriber_count_past_30_days).to eq hsh
      end

      it '.subscriber_count_past_14_days', :versioning => true do
        hsh = {}
        14.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n
        end

        expect(@channel.subscriber_count_past_14_days).to eq hsh
      end




      it '.video_count_past_30_days', :versioning => true do
        hsh = {}
        30.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n*2
        end

        expect(@channel.video_count_past_30_days).to eq hsh
      end

      it '.video_count_past_14_days', :versioning => true do
        hsh = {}
        14.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n*2
        end

        expect(@channel.video_count_past_14_days).to eq hsh
      end




      it '.view_count_past_30_days', :versioning => true do
        hsh = {}
        30.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n*10
        end

        expect(@channel.view_count_past_30_days).to eq hsh
      end

      it '.view_count_past_14_days', :versioning => true do
        hsh = {}
        14.times do |n|
          hsh[n.days.ago.strftime('%Y-%m-%d')] = n*10
        end

        expect(@channel.view_count_past_14_days).to eq hsh
      end


    end

    context 'iq score' do
      before(:each) do
        @channel = Channel.create(t_id: '1', view_count: 100, subscriber_count: 9000)
        @video = Video.create(t_id: 1, channel_id: 1, likes: 1, dislikes: 0)

      end

      it 'view_count_calculation' do
        expect(@channel.view_count_calculation).to eq 25
      end

      it 'subscriber_count_calculation' do
        expect(@channel.subscriber_count_calculation).to eq 75
      end

      it 'overall_approval_rating_of_videos_calculation' do
        expect(@channel.overall_approval_rating_of_videos_calculation).to eq 100
      end

    end





    context 'new iq score' do
      before(:each) do
        @channel = Channel.create(t_id: '1', view_count: 100, subscriber_count: 9000)
        @video = Video.create(t_id: 1, channel_id: 1, likes: 1, dislikes: 0)
      end

      it 'should initialize a new method' do
        c = IqScore::Calc.new(@channel)
        binding.pry
      end
    end

  end
end
