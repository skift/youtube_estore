require 'estore_conventions'


module YoutubeEstore
  module ApiFactory

    def self.Video(obj)
      attributes_hash = {}
      attributes_hash[:t_id] = obj[:id]
      attributes_hash[:published_at] = obj.snippet.publishedAt
      attributes_hash[:description] = obj.snippet.description
      attributes_hash[:username] = obj.snippet.title
      attributes_hash[:default_thumbnail] = obj.snippet.thumbnails[:default][:url]
      attributes_hash[:channel_id] = obj.snippet.channelId
      attributes_hash[:category_id] = obj.snippet.categoryId
      attributes_hash[:view_count] = obj.statistics.viewCount.to_i
      attributes_hash[:favorite_count] = obj.statistics.favoriteCount.to_i
      attributes_hash[:comment_count] = obj.statistics.commentCount.to_i
      attributes_hash[:likes] = obj.statistics.likeCount.to_i
      attributes_hash[:dislikes] = obj.statistics.dislikeCount.to_i
      attributes_hash[:view_count] = obj.statistics.viewCount.to_i
      attributes_hash[:duration_seconds] = Video.convert_iso8601_to_seconds(obj.contentDetails.duration)
      attributes_hash[:is_embeddable] = obj.status.embeddable

      EstoreConventions::Builder.build_from_object(Video, obj, attributes_hash)
    end

    
  end
end
