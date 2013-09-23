module YoutubeEstore
  module ApiFactory
    def self.Channel(obj)
      attributes_hash = {}
      attributes_hash[:published_at] = obj.snippet.publishedAt
      attributes_hash[:description] = obj.snippet.description
      attributes_hash[:subscriber_count] = obj.statistics.subscriberCount
      attributes_hash[:video_count] = obj.statistics.videoCount
      attributes_hash[:username] = obj.snippet.title
      attributes_hash[:view_count] = obj.statistics.viewCount
      attributes_hash[:default_thumbnail] = obj.snippet.thumbnails[:default][:url]
      attributes_hash[:t_id] = obj.id


      return Channel.new(attributes_hash)
    end
  end
end