# frozen_string_literal: true

module Dashboard
  module VideosHelper
    def dashboard_derive_video_list_params(filters = {})
      valid_filters = filters.slice(:sort, :page)
      url_for(request.query_parameters.merge(valid_filters))
    end

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
end
