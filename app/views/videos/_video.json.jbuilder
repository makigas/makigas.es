# frozen_string_literal: true

json.title video.title
json.description video.description
json.tags video.tags
json.slug video.slug
json.published_at video.published_at

if embeds.include?(:playlist)
  json.playlist do
    json.partial! video.playlist, as: :playlist, embeds: %i[topic]
  end
end

json.seconds video.duration
json.duration video.natural_duration
json.position video.position

json.twitch_id(video.twitch_id) if video.twitch_id.present?

json._links do
  json.self { json.href video_path(video) }
  json.shortlink { json.href "/v/#{video.youtube_id}" }
  json.icon do
    json.href "https://i1.ytimg.com/vi/#{video.youtube_id}/mqdefault.jpg"
    json.type 'image/jpeg'
    json.sizes '320x180'
  end
  json.set! 'makigas:youtube' do
    json.href "https://youtube.com/watch?v=#{video.youtube_id}"
  end
  if video.twitch_id.present?
    json.set! 'makigas:twitch' do
      json.href "https://twitch.tv/videos/#{video.twitch_id}"
    end
  end
  if embeds.include?(:playlist)
    json.set! 'makigas:playlist' do
      json.href playlist_path(video.playlist)
    end
  end
end
