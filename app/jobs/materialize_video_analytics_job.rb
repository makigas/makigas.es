class MaterializeVideoAnalyticsJob < ApplicationJob
  queue_as :default

  def video_path_from_sluggable(sluggable)
    # Sluggable: {slug: (video_slug), scope: playlist_id:(playlist_id)}
    scopes = sluggable.scope.split(",").map do |scope|
      column_name, _, column_value = scope.rpartition(":")
      [column_name, column_value.to_i]
    end.to_h

    playlist = Playlist.find(scopes["playlist_id"])
    Rails.application.routes.url_helpers.playlist_video_path(id: sluggable.slug, playlist_id: playlist.slug)
  end

  def update_without_timestamps
    old = ActiveRecord::Base.record_timestamps
    begin
      ActiveRecord::Base.record_timestamps = false
      yield
    ensure
      ActiveRecord::Base.record_timestamps = old
    end
  end

  def update_counters
    total_data = IngestedAnalytic.recordset.group_by_page
    recent_data = IngestedAnalytic.recordset.where('day >= ?', 30.days.ago).group_by_page
    Video.includes(:playlist).find_each do |video|
      urls = video.slug_history.map { |s| video_path_from_sluggable(s) }
      total = urls.map { |u| total_data[u] }.compact.sum
      recent = urls.map { |u| recent_data[u] }.compact.sum
      update_without_timestamps do
        video.update(views_total: total, views_recent: recent)
      end
    end
  end

  def percentile(data, p)
    avg_pos = (p / 100.0) * (data.length - 1)
    p_index = avg_pos.to_i
    interpolation = avg_pos - p_index
    if (p_index + 1) < data.length
      data[p_index] + interpolation * (data[p_index + 1] - data[p_index])
    else
      data[p_index]
    end
  end

  def update_tags
    views = Video.pluck(:views_recent).compact.sort
    max = views.max
    rising = percentile(views, 75)
    popular = percentile(views, 95)

    update_without_timestamps do
      Video.transaction do
        Video.update_all(trend_tag: nil)
        Video.where('views_recent >= ?', rising).update_all(trend_tag: 'rising')
        Video.where('views_recent >= ?', popular).update_all(trend_tag: 'popular')
      end
    end
  end

  def perform(*args)
    update_counters
    update_tags
  end
end
