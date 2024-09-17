# frozen_string_literal: true

class MaterializeVideoAnalyticsJob < ApplicationJob
  queue_as :default

  def video_path_from_sluggable(sluggable)
    # Sluggable: {slug: (video_slug), scope: playlist_id:(playlist_id)}
    scopes = sluggable.scope.split(',').to_h do |scope|
      column_name, _, column_value = scope.rpartition(':')
      [column_name, column_value.to_i]
    end

    playlist = Playlist.find(scopes['playlist_id'])
    Rails.application.routes.url_helpers.playlist_video_path(id: sluggable.slug, playlist_id: playlist.slug)
  end

  def update_without_timestamps(&)
    old = ActiveRecord::Base.record_timestamps
    begin
      ActiveRecord::Base.record_timestamps = false
      ActiveRecord::Base.transaction(&)
    ensure
      ActiveRecord::Base.record_timestamps = old
    end
  end

  def update_video_counters(video, total_data, recent_data)
    urls = video.slug_history.map { |s| video_path_from_sluggable(s) }
    total = urls.map { |u| total_data[u] }.compact.sum
    recent = urls.map { |u| recent_data[u] }.compact.sum
    update_without_timestamps do
      video.update(views_total: total, views_recent: recent)
    end
  end

  def update_playlist_counters(playlist, total_data, recent_data)
    url = Rails.application.routes.url_helpers.playlist_path(id: playlist.slug)
    update_without_timestamps do
      playlist.update(views_total: total_data[url], views_recent: recent_data[url])
    end
  end

  def update_aggregated_playlist_counter(group)
    count = Video.where(playlist_id: group.playlist_id).count
    group.playlist.update(aggregated_views_total: group.total, aggregated_views_recent: group.recent,
                          normalized_views_total: group.total / count,
                          normalized_views_recent: group.recent / count)
  end

  def update_aggregated_playlist_counters
    sums = Video.where.not(playlist_id: nil)
                .select('playlist_id', 'sum(views_total) as total', 'sum(views_recent) as recent')
                .group(:playlist_id)
    update_without_timestamps do
      sums.each { |group| update_aggregated_playlist_counter(group) }
    end
  end

  def update_counters
    total_data = IngestedAnalytic.recordset.group_by_page
    recent_data = IngestedAnalytic.recordset.where(day: 30.days.ago..).group_by_page
    Video.includes(:playlist).find_each do |video|
      update_video_counters(video, total_data, recent_data)
    end
    Playlist.find_each do |playlist|
      update_playlist_counters(playlist, total_data, recent_data)
    end
    update_aggregated_playlist_counters
  end

  def percentile(data, pvalue)
    avg_pos = (pvalue / 100.0) * (data.length - 1)
    p_index = avg_pos.to_i
    interpolation = avg_pos - p_index
    if (p_index + 1) < data.length
      data[p_index] + (interpolation * (data[p_index + 1] - data[p_index]))
    else
      data[p_index]
    end
  end

  def update_tags
    views = Video.pluck(:views_recent).compact.sort
    views.max
    rising = percentile(views, 75)
    popular = percentile(views, 95)

    update_without_timestamps do
      Video.update(trend_tag: nil)
      break if rising.zero?

      Video.where(views_recent: rising..).update(trend_tag: 'rising')
      Video.where(views_recent: popular..).update(trend_tag: 'popular')
    end
  end

  def perform(*_args)
    update_counters
    update_tags
  end
end
