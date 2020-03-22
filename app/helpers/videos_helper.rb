# frozen_string_literal: true

module VideosHelper
  def video_path(video, options = {})
    playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def video_url(video, options = {})
    playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end
end
