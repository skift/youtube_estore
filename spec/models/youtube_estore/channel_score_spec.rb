require 'spec_helper'

module YoutubeEstore
  describe Channel do

    context 'new iq score' do
      before(:each) do
        @channel = Channel.create(t_id: '1', view_count: 100, subscriber_count: 9000)
        @video = Video.create(t_id: 1, channel_id: 1, likes: 1, dislikes: 0)
      end

      it 'should initialize a new method' do
        c = IqScore::Calc.new(@channel)
        expect(c.calculate_total).to eq 40
        # binding.pry
      end
    end

  end
end
