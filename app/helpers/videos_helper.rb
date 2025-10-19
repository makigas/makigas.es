# frozen_string_literal: true

module VideosHelper
  def forum_utm_params(video)
    { campaign: 'NuevoForo2024', source: 'makigas.es', medium: 'SubBanner',
      terrm: video.playlist_id, content: video.id }
  end

  def video_path(video, options = {})
    playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def video_url(video, options = {})
    playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def video_search_duration_filters
    [['Cortos (<5 min)', 'short'],
     ['Medios (5 a 15 min)', 'medium'],
     ['Largos (>15 min)', 'long']]
  end

  def video_search_sort_criterias
    [['Más recientes', 'recent'],
     ['Más vistos', 'popular'],
     ['En tendencia', 'trending']]
  end
end
