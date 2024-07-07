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
#  index_ingested_analytics_on_day  (day)
#
class IngestedAnalytic < ApplicationRecord
  validates :day, presence: true, uniqueness: true
  validates :document, presence: true

  # SELECT ...
  #   FROM ingested_analytics
  #   JOIN jsonb_to_recordset(ingested_analytics.document)
  #        AS row(page text, pageviews int)
  #        ON true
  scope :recordset, -> { joins('JOIN jsonb_to_recordset(document) as row(page text, pageviews int) ON TRUE') }
  scope :by_page, ->(page) { recordset.where(row: { page: page }) }
  scope :group_by_page, -> {
    result = select('page', 'sum(pageviews) AS sum').group('page')
    result.map { |r| [r.page, r.sum] }.to_h
  }

  scope :total, -> { sum('pageviews') }
  scope :data, -> { pluck('day', 'page', 'pageviews') }
end
