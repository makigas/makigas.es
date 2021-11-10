# frozen_string_literal: true

class PlaylistHeaderComponent < ViewComponent::Base
  def initialize(playlist:)
    super
    @playlist = playlist
  end

  def duration
    duration = helpers.running_time total_seconds, long: true
    duration.split(':').take(2).join(':')
  end

  private

  def total_seconds
    @playlist.videos.map(&:duration).sum
  end
end
