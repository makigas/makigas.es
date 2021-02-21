# frozen_string_literal: true

json.recent do
  json.array! @recent, partial: 'videos/video', as: :video, embeds: %i[playlist]
end

json._links do
  json.set! 'makigas:topics' do
    json.href topics_path
  end
  json.set! 'makigas:playlists' do
    json.href playlists_path
  end
  json.set! 'makigas:videos' do
    json.href videos_path
  end
end
