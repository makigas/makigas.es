class PlaylistCardComponent < ViewComponent::Base
  include ViewComponent::Translatable

  with_collection_parameter :playlist

  def initialize(playlist:)
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
