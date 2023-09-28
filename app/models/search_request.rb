# frozen_string_literal: true

# == Schema Information
#
# Table name: search_requests
#
#  id         :bigint           not null, primary key
#  count      :integer          default(0), not null
#  error      :string
#  filters    :jsonb            not null
#  page       :integer          default(1)
#  query      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_search_requests_on_filters  (filters) USING gin
#  index_search_requests_on_query    (query)
#
class SearchRequest < ApplicationRecord
  def full_criteria
    filters.merge(page:)
  end

  def empty_page?
    count.zero?
  end
end
