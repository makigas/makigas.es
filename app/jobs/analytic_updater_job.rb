# frozen_string_literal: true

class AnalyticUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    analytic_information.save
    MaterializeVideoAnalyticsJob.perform_now
  end

  def analytic_information
    yesterday = Time.now.utc.to_date.yesterday
    @analytic_information ||= Plausible::Downloader.entity_for_day(yesterday)
  end
end
