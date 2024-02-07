# frozen_string_literal: true

class VideoSorter
  def initialize(query: nil)
    @query = query
  end

  def videos
    Video.order(order_criteria)
  end

  def flip(crit)
    return crit if crit != criteria

    case order
    when :asc
      criteria
    when :desc
      "-#{criteria}"
    end
  end

  def arrow(crit)
    return '' if crit != criteria

    case order
    when :asc
      '↑'
    when :desc
      '↓'
    end
  end

  private

  attr_reader :query

  SQL_MAPPINGS = {
    'created' => 'created_at',
    'updated' => 'updated_at',
    'released' => 'published_at'
  }.freeze

  def order
    if query.starts_with?('-')
      :asc
    else
      :desc
    end
  end

  def criteria
    if query.present? && query.starts_with?('-')
      query[1..]
    else
      query
    end
  end

  def order_criteria
    { SQL_MAPPINGS[criteria] => order } if criteria.present?
  end
end
