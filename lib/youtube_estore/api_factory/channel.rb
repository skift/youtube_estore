module YoutubeEstore
  module ApiFactory
    def self.Channel(obj)
      attributes_hash = {}
      attributes_hash[:published_at] = obj.snippet.publishedAt
      attributes_hash[:description] = obj.snippet.description[0..254]
      attributes_hash[:subscriber_count] = obj.statistics.subscriberCount
      attributes_hash[:video_count] = obj.statistics.videoCount
      attributes_hash[:title] = obj.snippet.title
      attributes_hash[:view_count] = obj.statistics.viewCount
      attributes_hash[:default_thumbnail] = obj.snippet.thumbnails[:default][:url]
      attributes_hash[:t_id] = obj[:id]

      attributes_hash[:username] = obj[:username] if obj[:username]

      # note :username appears to be deprecated from official api

#      EstoreConventions::Builder.build_from_object(Channel, obj, attributes_hash)


      identifier_hash = {t_id: attributes_hash[:t_id] }
      video = Channel.factory_build_for_store( attributes_hash, identifier_hash, obj  )

    end    
  end
end
