module VideosHelper

  def video_path video
    playlist_video_path video, playlist_id: video.playlist
  end

end
