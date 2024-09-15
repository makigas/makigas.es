# frozen_string_literal: true

module PlaylistsHelper
  # rubocop:disable Metrics/MethodLength
  def playlist_jsonld(playlist)
    playlist.creative_work_series.deep_merge(
      '@context': 'https://schema.org/',
      '@type': 'CreativeWorkSeries',
      publisher: {
        '@type': 'Organization',
        name: 'makigas',
        url: 'https://www.makigas.es'
      },
      url: playlist_path(playlist),
      sameAs: "https://www.youtube.com/playlist?list=#{playlist.youtube_id}",
      author: {
        '@type': 'Person',
        name: 'Dani Rodríguez'
      }
    )
  end
  # rubocop:enable Metrics/MethodLength

  def derive_playlists_url(filters)
    valid_filters = filters.slice(:topic, :sort)
    url_for(request.query_parameters.merge(valid_filters))
  end
end
