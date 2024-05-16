# frozen_string_literal: true

json.title topic.title
json.description topic.description
json.slug topic.slug
json.color topic.color

if embeds.include?(:playlists)
  json.playlists do
    json.array! topic.playlists.order(topic_position: :asc), partial: 'playlists/playlist', as: :playlist, embeds: []
  end
end

json._links do
  json.self { json.href topic_path(topic) }
  json.collection { json.href topics_path }
  json.icon topic.icons
end
