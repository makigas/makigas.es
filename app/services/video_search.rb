# frozen_string_literal: true

class VideoSearch
  def initialize(query, page: 1, filters: {})
    @query = query
    @page = page
    @filters = filters
  end

  def videos
    Video.search(@query, { filter: search_filters, hitsPerPage: 10, page: @page })
  end

  private

  attr_reader :filters

  LENGTH_QUERIES = {
    'short' => ['duration <= 300'],
    'medium' => ['duration > 300', 'duration <= 900'],
    'long' => ['duration > 900'],
    'all' => []
  }.freeze

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
