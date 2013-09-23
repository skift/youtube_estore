module YoutubeEstore
  class Channel < ActiveRecord::Base
    # attr_accessible :title, :body
    has_many :videos, primary_key: :t_id 
    validates_presence_of :t_id
    validates_uniqueness_of :t_id

    attr_accessible :age, :description, :subscriber_count, :video_count, :username, :view_count, :default_thumbnail, :t_id





    def method_missing(meth, *args, &block)
      if meth.match(/(\w+)(?:_of_videos|_videos)$/)
        foo = $1
        videos.send(foo, *args, &block)
      else
        super
      end
    end


    def respond_to?(meth, x=false)
      if meth.match(/(\w+)(?:_of_videos|_videos)$/)
        true
      else
        super
      end
    end

  end
end
