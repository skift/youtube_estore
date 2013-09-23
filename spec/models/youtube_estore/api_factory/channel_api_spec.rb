require 'spec_helper'

module YoutubeEstore
  module ApiFactory 
    

    describe 'ApiFactory.Channel' do 
      before(:all) do 
        @channel_object = Testdatum('channel')
      end

      context 'initialization' do 
        it 'should return a Channel' do 
          expect(ApiFactory.Channel(@channel_object)).to be_a Channel
        end

        it 'should be a new, unsaved Channel' do 
          expect(ApiFactory.Channel(@channel_object)).to be_new_record
        end

        it 'should have a t_id set to id of the youtube data object' do 
          expect(ApiFactory.Channel(@channel_object).t_id).to eq @channel_object[:id]
        end
      end



      describe 'attribute transformation' do 
        before(:each) do 
          @channel = ApiFactory.Channel(@channel_object)
        end

        context 'descriptive attributes' do
          it 'should set :published_at to obj.snippet.publishedAt' do
            expect(@channel.published_at).to eq @channel_object.snippet.publishedAt
          end

          it 'should set :description to obj.snippet.description' do 
            expect(@channel.description).to eq @channel_object.snippet.description
          end

          it 'should set :username to obj.snippet.title' do 
            expect(@channel.username).to eq @channel_object.snippet.title
          end

          it 'should set :default_thumbnail to obj.snippet.thumbnails[:default][:url]' do 
            expect(@channel.default_thumbnail).to eq @channel_object.snippet.thumbnails[:default][:url]
          end
        end

        context 'statistical attributes' do 
          it 'should set :subscriber_count to obj.statistics.subscriberCount' do 
            expect(@channel.subscriber_count).to eq @channel_object.statistics.subscriberCount.to_i
          end

          it 'should set :video_count to obj.statistics.videoCount' do 
            expect(@channel.video_count).to eq @channel_object.statistics.videoCount.to_i
          end

          it 'should set :view_count to obj.statistics.viewCount' do 
            expect(@channel.view_count).to eq @channel_object.statistics.viewCount.to_i
          end
        end
      end
    end
  end
end