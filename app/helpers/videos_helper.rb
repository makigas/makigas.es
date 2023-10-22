# frozen_string_literal: true

module VideosHelper
  def forum_utm_params(video)
    { campaign: 'NuevoForo2024', source: 'makigas.es', medium: 'SubBanner',
      terrm: video.playlist_id, content: video.id }
  end

  # rubocop:disable Metrics/MethodLength
  def video_episode_jsonld(video)
    video.to_episode_schema.merge(partOfSeries: playlist_jsonld(video.playlist)).deep_merge(
      '@context': 'https://schema.org/',
      '@type': 'Episode',
      publisher: {
        '@type': 'Organization',
        name: 'makigas',
        url: 'https://www.makigas.es'
      },
      author: {
        '@type': 'Person',
        name: 'Dani Rodríguez'
      }
    )
  end
  # rubocop:enable Metrics/MethodLength

  def video_object_jsonld(video)
    video.to_video_schema.merge(encodesCreativeWork: video_episode_jsonld(video)).deep_merge(
      '@context': 'https://schema.org/',
      '@type': 'VideoObject',
      sameAs: "https://www.youtube.com/watch?v=#{video.youtube_id}",
      url: playlist_video_path(video, playlist_id: video.playlist_id)
    )
  end

  def video_path(video, options = {})
    playlist_video_path(video, options.merge(playlist_id: video.playlist))
  end

  def video_url(video, options = {})
    playlist_video_url(video, options.merge(playlist_id: video.playlist))
  end

  def derive_search_url(filters = {})
    valid_filters = filters.slice(:tag, :topic, :length, :q)
    url_for(request.query_parameters.merge(valid_filters))
  end

  def video_search_duration_filters
    [['Cortos (<5 min)', 'short'],
     ['Medios (5 a 15 min)', 'medium'],
     ['Largos (>15 min)', 'long']]
  end
end
