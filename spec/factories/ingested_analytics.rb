# frozen_string_literal: true

# == Schema Information
#
# Table name: ingested_analytics
#
#  id         :bigint           not null, primary key
#  day        :date             not null
#  document   :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ingested_analytics_on_day        (day) UNIQUE
#  index_ingested_analytics_on_document_  (document) USING gin
#
FactoryBot.define do
  factory :ingested_analytic do
    day { '2024-06-23' }
    document { [{ 'page' => '/series/cocina/como-cocinar-estofado', 'pageviews' => 5 }] }
  end
end
