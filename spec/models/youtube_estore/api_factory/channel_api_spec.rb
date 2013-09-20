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

        # it must set t_id
        it 'should be a new, unsaved Channel' do 
          expect(ApiFactory.Channel(@channel_object).t_id).to eq @channel_object[:id]
        end
      end



      describe 'attribute transformation' do 
        before(:each) do 
          @channel = ApiFactory.Channel(@channel_object)
        end

        context 'descriptive attributes' do 
          it 'should set :description to obj.snippet.description' do 
            expect(@channel.description).to eq @channel_object.snippet.description
          end
        end


        context 'statistical attributes' do 
          it 'should set :subscriber_count to obj.statistics.subscriberCount' do 
            expect(@channel.subscriber_count).to eq @channel_object.statistics.subscriberCount.to_i
          end
        end
      end
    

    end
  end
end