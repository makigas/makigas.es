# frozen_string_literal: true

module Search
  class QueryParamsDeserializer
    CONTENT_TYPES = {
      'videos' => :videos,
      'cursos' => :playlists
    }.freeze

    SORT_CRITERIAS = {
      'relevancia' => :relevance,
      'reciente' => :recent,
      'popular' => :popular,
      'tendencia' => :trending
    }.freeze

    class << self
      def convert(params)
        new(params).convert
      end
    end

    def initialize(params)
      @params = ActiveSupport::HashWithIndifferentAccess.new(params)
    end

    def convert
      Search::Filters.new(cast).tap(&:clean!)
    end

    private

    attr_reader :params

    def cast
      { query: params[:q],
        page: params[:pagina],
        tag: params[:tag],
        content_type: CONTENT_TYPES.fetch(in_content_type, nil),
        sort: SORT_CRITERIAS.fetch(in_sort, nil),
        exclude_obsolete: params['sin-obsoletos'].present?,
        articles: params[:articulos].present? }.compact_blank
    end

    def in_content_type
      params[:type].try(:to_s)
    end

    def in_sort
      params[:orden].try(:to_s)
    end
  end
end
