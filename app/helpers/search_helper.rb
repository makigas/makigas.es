# frozen_string_literal: true

module SearchHelper
  def search_result_playlist(playlist)
    { title: playlist.title,
      description: playlist.description,
      url: playlist_path(playlist),
      label: 'Curso',
      icon: playlist.thumbnail.url(:small),
      icon_hd: playlist.thumbnail.url(:hidef) }
  end

  def search_result_video(video)
    { title: video.title,
      description: video.description,
      url: playlist_video_path(video, playlist_id: video.playlist),
      label: 'Lección',
      icon: "https://i1.ytimg.com/vi/#{video.youtube_id}/mqdefault.jpg",
      icon_hd: "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg",
      trend: video.trend_tag }
  end

  def search_result_params(hit)
    if hit.is_a?(Playlist)
      search_result_playlist(hit)
    elsif hit.is_a?(Video)
      search_result_video(hit)
    end
  end

  def derive_search_url(current_filters, **params)
    new_filters = current_filters.derive(**params)
    new_params = Search::QueryParamsSerializer.convert(new_filters)
    search_path(new_params.symbolize_keys)
  end
end
