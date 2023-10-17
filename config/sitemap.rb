# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://www.makigas.es'
SitemapGenerator::Sitemap.create do
  add root_path, priority: 0.9, changefreq: 'daily'

  # Videos
  add videos_path, priority: 0.9, changefreq: 'daily'

  # Playlists
  add playlists_path, priority: 0.9, changefreq: 'weekly'
  Playlist.find_each do |playlist|
    add playlist_path(playlist), priority: 0.8, changefreq: 'weekly', lastmod: playlist.content_updated_at
    playlist.videos.visible.find_each do |video|
      add playlist_video_path(video, playlist_id: playlist), priority: 0.8, lastmod: video.updated_at
    end
  end

  # Topics
  add topics_path, priority: 0.8, changefreq: 'weekly'
  Topic.find_each do |topic|
    add topic_path(topic), priority: 0.7, changefreq: 'weekly', lastmod: topic.content_updated_at
  end

  add terms_path, priority: 0.5
  add privacy_path, priority: 0.5
  add cookies_path, priority: 0.5
  add disclaimer_path, priority: 0.5
  add discord_path, priority: 0.5
end
