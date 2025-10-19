# frozen_string_literal: true

json.key_format! camelize: :lower

json.set! '@context', 'https://schema.org'
json.set! '@type', 'VideoObject'

json.name video.title
json.description video.excerpt
json.thumbnail_url "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg"
json.upload_date video.published_at ? video.published_at&.iso8601 : video.created_at.iso8601
json.duration ActiveSupport::Duration.build(video.duration).iso8601
json.embed_url "https://www.youtube.com/embed/#{video.youtube_id}"

json.same_as "https://www.youtube.com/watch?v=#{video.youtube_id}"
json.url playlist_video_url(video, playlist_id: video.playlist)
