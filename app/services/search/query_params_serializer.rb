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
      ActiveSupport::HashWithIndifferentAccess.new(compact_params)
    end

    private

    def compact_params
      clean_cast.then do |params|
        # For some reason, the URL helper will not reset the type if switching from something to nil,
        # unless the value is manually present in the array. Therefore, :type cannot be compacted.
        clean_params = params.compact
        clean_params[:type] ||= nil
        clean_params
      end
    end

    attr_reader :filters

    def clean_cast
      cast.tap do |params|
        params.delete(:pagina) if params.include?(:pagina) && params[:pagina] == 1
        params.delete(:orden) if params[:orden] == SORT_CRITERIAS[default_sort_criteria]
      end
    end

    def default_sort_criteria
      if filters.query.present?
        :relevance
      else
        :recent
      end
    end

    def cast
      { q: filters.query,
        pagina: filters.page,
        type: CONTENT_TYPES[filters.content_type],
        tag: filters.tag,
        orden: SORT_CRITERIAS[filters.sort],
        'sin-obsoletos' => filters.exclude_obsolete ? '1' : nil,
        articulos: filters.articles ? '1' : nil }
    end
  end
end
