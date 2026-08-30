# frozen_string_literal: true

json.title playlist.title
json.description playlist.description
json.slug playlist.slug
json.count playlist.videos.count

if embeds.include?(:videos)
  json.videos do
    json.array! playlist.videos, partial: 'videos/video', as: :video, embeds: []
  end
end

json._links do
  json.self { json.href playlist_path(playlist) }
  json.collection { json.href playlists_path }
  json.icon do
    json.array! playlist.icons do |icon|
      json.href url_for(icon[:attachment])
      json.type icon[:type]
      json.sizes icon[:sizes]
    end
  end
  json.set! 'makigas:card' do
    json.array! playlist.cards do |card|
      json.href url_for(card[:attachment])
      json.type card[:type]
      json.sizes card[:sizes]
    end
  end
  json.set! 'makigas:youtube' do
    json.href "https://youtube.com/playlist?list=#{playlist.youtube_id}"
  end
  if playlist.display_forum_url.present?
    json.set! 'makigas:forum' do
      json.href playlist.display_forum_url
    end
  end
end
