# frozen_string_literal: true

json.topics do
  json.array! @topics, partial: 'topics/topic', as: :topic, embeds: []
end

json._links do
  json.self { json.href topics_path }
end
