module Dashboard::VideosHelper
  def dashboard_video_path(video, options = {})
    dashboard_playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def edit_dashboard_video_path(video, options = {})
    edit_dashboard_playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def move_dashboard_video_path(video, options = {})
    move_dashboard_playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def dashboard_video_url(video, options = {})
    dashboard_playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def edit_dashboard_video_url(video, options = {})
    edit_dashboard_playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def move_dashboard_video_url(video, options = {})
    move_dashboard_playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end
end
