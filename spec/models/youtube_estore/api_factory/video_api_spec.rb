require 'spec_helper'

module YoutubeEstore
  module ApiFactory 
    
    describe 'ApiFactory.Video' do 
      before(:all) do 
        @video_object = Testdatum('video')
      end

      context 'initialization' do 
        it 'should return a Video' do 
          expect(ApiFactory.Video(@video_object)).to be_a Video
        end

        it 'should be a new, unsaved Video' do 
          expect(ApiFactory.Video(@video_object)).to be_new_record
        end

        it 'should have a t_id set to id of the youtube data object' do 
          expect(ApiFactory.Video(@video_object).t_id).to eq @video_object[:id]
        end
      end

      describe 'attribute transformation' do 
        before(:each) do 
          @video = ApiFactory.Video(@video_object)
          @video.save
          @video = Video.first
        end

        context 'descriptive attributes' do
          it 'should set :published_at to obj.snippet.publishedAt' do
            expect(@video.published_at).to eq @video_object.snippet.publishedAt
          end

          it 'should set :description to obj.snippet.description' do 
            expect(@video.description).to eq @video_object.snippet.description[0..254]
          end

          it 'should set :username to obj.snippet.title' do 
            expect(@video.username).to eq @video_object.snippet.title
          end

          it 'should set :default_thumbnail to obj.snippet.thumbnails[:default][:url]' do 
            expect(@video.default_thumbnail).to eq @video_object.snippet.thumbnails[:default][:url]
          end

          it 'should set :channel_id to obj.snippet.channelId' do 
            expect(@video.channel_id).to eq @video_object.snippet.channelId
          end

          it 'should set :category_id to obj.snippet.categoryId' do 
            expect(@video.category_id).to eq @video_object.snippet.categoryId
          end
        end

        context 'statistical attributes' do 
          it 'should set :view_count to obj.statistics.viewCount' do 
            expect(@video.view_count).to eq @video_object.statistics.viewCount.to_i
          end

          it 'should set :favorite_count to obj.statistics.favoriteCount' do 
            expect(@video.favorite_count).to eq @video_object.statistics.favoriteCount.to_i
          end

          it 'should set :comment_count to obj.statistics.commentCount' do 
            expect(@video.comment_count).to eq @video_object.statistics.commentCount.to_i
          end

          it 'should set :likes to obj.statistics.likeCount' do 
            expect(@video.likes).to eq @video_object.statistics.likeCount.to_i
          end

          it 'should set :dislikes to obj.statistics.dislikeCount' do 
            expect(@video.dislikes).to eq @video_object.statistics.dislikeCount.to_i
          end

          it 'should set :view_count to obj.statistics.viewCount' do 
            expect(@video.view_count).to eq @video_object.statistics.viewCount.to_i
          end
        end

        context 'content attributes' do 
          it 'should set :duration_seconds to obj.contentDetails.duration' do 
            expect(@video.duration_seconds).to eq Video.convert_iso8601_to_seconds(@video_object.contentDetails.duration)
          end
        end

        context 'status attributes' do 
          it 'should set :is_embeddable to obj.status.embeddable' do 
            expect(@video.is_embeddable).to eq @video_object.status.embeddable
          end
        end

      end
    end
  end
end