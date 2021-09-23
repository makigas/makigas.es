# frozen_string_literal: true

class PlaylistVideoCardComponent < ViewComponent::Base
  include ViewComponent::Translatable

  with_collection_parameter :video

  def initialize(video:)
    @video = video
  end

  def duration
    helpers.running_time(@video.duration)
  end

  def published_at
    helpers.l @video.published_at.to_date, format: :long
  end
end
