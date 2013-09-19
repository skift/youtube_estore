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

  end
end
