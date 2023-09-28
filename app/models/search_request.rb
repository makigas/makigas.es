# == Schema Information
#
# Table name: search_requests
#
#  id         :bigint           not null, primary key
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
end
