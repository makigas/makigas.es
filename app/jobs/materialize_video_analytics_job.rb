class MaterializeVideoAnalyticsJob < ApplicationJob
  queue_as :default

  def video_path(video)
    Rails.application.routes.url_helpers.playlist_video_path(id: video.slug, playlist_id: video.playlist.slug)
  end

  # Sluggable: {slug: (video_slug), scope: playlist_id:(playlist_id)}
  def video_path_from_sluggable(sluggable)
    scopes = sluggable.scope.split(",").map do |scope|
      column_name, _, column_value = scope.rpartition(":")
      [column_name, column_value.to_i]
    end.to_h

    playlist = Playlist.find(scopes["playlist_id"])
    Rails.application.routes.url_helpers.playlist_video_path(id: sluggable.slug, playlist_id: playlist.slug)
  end

  def perform(*args)
    total_data = IngestedAnalytic.recordset.group_by_page
    recent_data = IngestedAnalytic.recordset.where('day >= ?', 30.days.ago).group_by_page
    Video.includes(:playlist).find_each do |video|
      slugs = video.slug_history
      urls = slugs.map { |s| video_path_from_sluggable(s) }

      total = urls.map { |u| total_data[u] }.compact.sum
      recent = urls.map { |u| recent_data[u] }.compact.sum

      o = video.record_timestamps
      begin
        video.record_timestamps = false
        video.update(views_total: total, views_recent: recent)
      ensure
        video.record_timestamps = o
      end
    end
  end
end
