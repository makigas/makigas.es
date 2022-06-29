# frozen_string_literal: true

json.videos do
  json.array! @videos, partial: 'videos/video', as: :video, embeds: %i[playlist]
end
