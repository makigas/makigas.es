# frozen_string_literal: true

json.videos do
  json.array! @videos, partial: 'videos/video', as: :video, embeds: %i[playlist]
end

json._links do
  json.self { json.href videos_path }
  json.next { json.href url_for(request.params.merge(page: @paginator.next_page)) } unless @paginator.last_page?
  json.prev { json.href url_for(request.params.merge(page: @paginator.prev_page)) } unless @paginator.first_page?
  json.set! 'makigas:filter' do
    json.href "#{videos_path}{?q,page,tag,sort}"
    json.templated true
  end
end
