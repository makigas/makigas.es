class MaterializeVideoAnalyticsJob < ApplicationJob
  queue_as :default

  def video_path(video)
    Rails.application.routes.url_helpers.playlist_video_path(id: video.slug, playlist_id: video.playlist.slug)
  end

  def perform(*args)
    total_data = IngestedAnalytic.recordset.group_by_page
    recent_data = IngestedAnalytic.recordset.where('day >= ?', 30.days.ago).group_by_page
    Video.includes(:playlist).find_each do |video|
      url = video_path(video)
      total = total_data[url]
      recent = recent_data[url]
      video.update(views_total: total, views_recent: recent)
    end
  end
end
