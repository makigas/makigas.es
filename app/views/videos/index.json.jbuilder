# frozen_string_literal: true

json.videos do
  json.array! @videos, partial: 'videos/video', as: :video, embeds: %i[playlist]
end

json._links do
  json.self { json.href videos_path }
  json.next { json.href path_to_next_page(@videos) } if @videos.next_page.present?
  json.prev { json.href path_to_prev_page(@videos) } if @videos.prev_page.present?
  json.set! 'makigas:filter' do
    json.href "#{videos_path}{?length,topic[]*}"
    json.templated true
  end
end
