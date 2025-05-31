# frozen_string_literal: true

module Search
  # Converts a Search::Filter to the query params string for the website
  class QueryParamsSerializer
    CONTENT_TYPES = {
      videos: 'videos',
      playlists: 'cursos'
    }.freeze

    SORT_CRITERIAS = {
      relevance: 'relevancia',
      recent: 'reciente',
      popular: 'popular',
      trending: 'tendencia'
    }.freeze

    class << self
      def convert(params)
        new(params).convert
      end
    end

    def initialize(filters)
      @filters = filters
    end

    def convert
      ActiveSupport::HashWithIndifferentAccess.new(clean_cast.compact)
    end

    private

    attr_reader :filters

    def clean_cast
      cast.tap do |params|
        params.delete(:pagina) if params.include?(:pagina) && params[:pagina] == 1
      end
    end

    def cast
      { q: filters.query,
        pagina: filters.page,
        type: CONTENT_TYPES[filters.content_type],
        orden: SORT_CRITERIAS[filters.sort],
        'sin-obsoletos' => filters.exclude_obsolete ? '1' : nil,
        articulos: filters.articles ? '1' : nil }
    end
  end
end
