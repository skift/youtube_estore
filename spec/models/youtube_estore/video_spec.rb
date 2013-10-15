require 'spec_helper'

module YoutubeEstore
  describe Video do
    
    it 'should belong to a user' do 
      @video = Video.create(t_id: 1)
      @channel = Channel.create(t_id: 2)
      @video.channel = @channel

      expect(@video.channel.t_id).to eq 2
    end

    context 't_id' do 
      it 'should be valid with simply a t_id' do
        @video = YoutubeEstore::Video.new(t_id: 1)
        @video.save!
        expect(@video.valid?).to be_true  
        expect(@video.t_id).to eq 1
        expect(Video.count).to eq 1
      end

      it 'should not validate with no t_id' do 
        @video = YoutubeEstore::Video.new(t_id: nil)
        expect(@video.valid?).not_to be_true
      end
    end



  end
end