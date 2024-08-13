class AnalyticUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    analytic_information.save
    MaterializeVideoAnalyticsJob.perform_now
  end

  def analytic_information
    yesterday = Time.now.utc.to_date.yesterday
    @_analytic_information ||= Plausible::Downloader.entity_for_day(yesterday)
  end
end
