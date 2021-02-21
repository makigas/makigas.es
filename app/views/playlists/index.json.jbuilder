# frozen_string_literal: true

json.playlists do
  json.array! @playlists, partial: 'playlists/playlist', as: :playlist, embeds: []
end

json._links do
  json.self { json.href playlists_path }
  json.next { json.href path_to_next_page(@playlists) } if @playlists.next_page.present?
  json.prev { json.href path_to_prev_page(@playlists) } if @playlists.prev_page.present?
end
