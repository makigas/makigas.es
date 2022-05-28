# frozen_string_literal: true

module VideosHelper
  def video_path(video, options = {})
    playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def video_url(video, options = {})
    playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def derive_search_url(filters = {})
    valid_filters = filters.slice(:tag, :topic, :length)
    url_for(request.query_parameters.merge(valid_filters))
  end

  def video_search_duration_filters
    [['Cortos (<5 min)', 'short'],
     ['Medios (5 a 15 min)', 'medium'],
     ['Largos (>15 min)', 'long']]
  end
end
