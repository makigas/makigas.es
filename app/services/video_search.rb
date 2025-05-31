# frozen_string_literal: true

class VideoSearch
  def initialize(query, page: 1, filters: {}, sort: nil)
    @query = query
    @page = page
    @filters = filters
    @sort = sort
  end

  def videos
    Video.visible.includes(playlist: :topic).search(@query, meilisearch_filters).tap do |v|
      search_request.tap { |s| s.count = v.length }
    end
  rescue Meilisearch::CommunicationError => e
    search_request.error = e.message
    raise Makigas::SearchError, e.message
  end

  def search_request
    @search_request ||= SearchRequest.new(query: @query, page: @page, filters: @filters, sort: @sort)
  end

  private

  attr_reader :filters, :sort

  def meilisearch_filters
    { filter: search_filters, hitsPerPage: 10, page: @page, sort: sort_criteria }
  end

  SORT_QUERIES = {
    'relevance' => '',
    'recent' => 'publication_date:desc',
    'popular' => 'views_total:desc',
    'trending' => 'views_recent:desc'
  }.freeze

  LENGTH_QUERIES = {
    'short' => ['duration <= 300'],
    'medium' => ['duration > 300', 'duration <= 900'],
    'long' => ['duration > 900'],
    'all' => []
  }.freeze

  def sort_criteria
    return nil if sort.blank?

    criteria = SORT_QUERIES[sort]
    criteria.present? ? [criteria] : nil
  end

  def search_filters
    length_filters + topic_filters + tag_filter
  end

  def length_filters
    LENGTH_QUERIES[filters[:length].to_s] || []
  end

  def tag_filter
    if filters[:tag].present?
      ["tags = #{filters[:tag]}"]
    else
      []
    end
  end

  def topic_filters
    if filters[:topic].present?
      # Limit filters[:topic] so that it only contains real slugs.
      topics = Topic.where(slug: filters[:topic]).pluck(:slug)

      # Wrap topics in another array to make an OR filter.
      [topics.map { |t| "topic_slug = #{t}" }]
    else
      []
    end
  end
end
