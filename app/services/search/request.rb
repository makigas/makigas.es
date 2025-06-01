# frozen_string_literal: true

module Search
  class Request
    def initialize(params)
      @params = params
    end

    delegate :hits, to: :results

    def total_pages
      total_hits = results.metadata['estimatedTotalHits']
      limit = results.metadata['limit']
      (total_hits.to_f / limit).ceil
    end

    private

    def results
      @results ||= Meilisearch::Rails.federated_search(queries:, federation:)
    end

    def queries
      [].tap do |queries|
        queries << video_query if search_for?(:videos)
        queries << playlist_query if search_for?(:playlists)
      end
    end

    # search_for(:videos) will return true if no content type is filtered or if it is :videos
    # Ready for the future once searching for playlists is a thing.
    def search_for?(type)
      params.content_type.blank? || params.content_type == type
    end

    def clean_sort_criteria(hash, value)
      value = hash.fetch(value, nil)
      [value] if value.present?
    end

    VIDEO_SORT_CRITERIAS = {
      relevance: nil,
      recent: 'publication_date:desc',
      popular: 'views_total:desc',
      trending: 'views_recent:desc'
    }.freeze

    def video_query
      { q: params.query,
        filter: video_filters,
        sort: clean_sort_criteria(VIDEO_SORT_CRITERIAS, params.sort),
        scope: Video.searchable }.compact
    end

    def video_filters
      [].tap do |filters|
        filters << "tags = #{params.tag}" if params.tag.present?
        filters << 'deprecated = false' if params.exclude_obsolete
        filters << 'has_show_note = true' if params.articles
      end
    end

    PLAYLIST_SORT_CRITERIAS = {
      relevance: nil,
      recent: 'last_publication_date:desc',
      popular: 'views_total:desc',
      trending: 'views_recent:desc'
    }.freeze

    def playlist_query
      { q: params.query,
        filter: playlist_filters,
        sort: clean_sort_criteria(PLAYLIST_SORT_CRITERIAS, params.sort),
        scope: Playlist.searchable,
        # TODO: let me customize the weights in a configuration panel
        # Make the weight only increase by a slight percentage, not more
        # than 5%, because there are too many decimals and the results
        # will be skewed.
        federation_options: { weight: 1.03 } }.compact
    end

    def playlist_filters
      [].tap do |filters|
        filters << "episode_tags = #{params.tag}" if params.tag.present?
        filters << 'deprecated = false' if params.exclude_obsolete
        filters << 'has_show_notes = true' if params.articles
      end
    end

    def federation
      page = params.page
      per_page = params.per_page
      { offset: (page - 1) * per_page, limit: per_page }
    end

    attr_reader :params
  end
end
