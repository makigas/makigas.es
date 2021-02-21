# frozen_string_literal: true

json.title playlist.title
json.description playlist.description
json.slug playlist.slug
json.count playlist.videos.count

if embeds.include?(:topic) && playlist.topic.present?
  json.topic do
    json.partial! playlist.topic, as: :topic, embeds: []
  end
end

if embeds.include?(:videos)
  json.videos do
    json.array! playlist.videos, partial: 'videos/video', as: :video, embeds: []
  end
end

json._links do
  json.self { json.href playlist_path(playlist) }
  json.collection { json.href playlists_path }
  json.icon playlist.icons
  json.set! 'makigas:youtube' do
    json.href "https://youtube.com/playlist?list=#{playlist.youtube_id}"
  end
  if embeds.include?(:topic) && playlist.topic.present?
    json.set! 'makigas:topic' do
      json.href topic_path(playlist.topic)
    end
  end
end
