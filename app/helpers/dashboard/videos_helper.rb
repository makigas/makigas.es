module Dashboard::VideosHelper
  def video_path(video, options = {})
    playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def edit_video_path(video, options = {})
    edit_playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def move_video_path(video, options = {})
    move_playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def video_url(video, options = {})
    playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def edit_video_url(video, options = {})
    edit_playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def move_video_url(video, options = {})
    move_playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end
end
