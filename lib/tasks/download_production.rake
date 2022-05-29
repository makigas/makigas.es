# frozen_string_literal: true

class DownloadProduction
  include Rake::DSL

  def initialize
    @playlists = {}
    @topics = {}
    namespace :makigas do
      desc 'Downloads a copy of the contents of production'
      task download_production: :environment do
        download_production
      end
    end
  end

  private

  ROOT_URL = 'https://www.makigas.es'

  CLIENT_HEADERS = {
    Accept: 'application/json'
  }.freeze

  def download_production
    Video.acts_as_list_no_update do
      recursive_fetch('/videos', 'videos') do |video|
        upsert_video(video)
      end
    end
  end

  def upsert_video(video)
    playlist = upsert_playlist(video['playlist']) if video['playlist'].present?
    playlist.videos.find_or_initialize_by(slug: video['slug']).tap do |v|
      v.update(video_attributes(video))
    end
  end

  def video_attributes(video)
    { title: video['title'],
      description: video['description'],
      youtube_id: video['_links']['makigas:youtube']['href'].gsub('https://youtube.com/watch?v=', ''),
      duration: video['seconds'],
      position: video['position'],
      tags: video['tags'],
      published_at: video['published_at'] }
  end

  def upsert_playlist(playlist)
    @playlists[playlist['slug']] ||= Playlist.find_or_initialize_by(slug: playlist['slug']).tap do |p|
      attributes = playlist_attributes(playlist)
      attributes[:topic] = upsert_topic(playlist['topic']) if playlist['topic'].present?
      p.update(attributes)
    end
  end

  def playlist_attributes(playlist)
    { title: playlist['title'],
      description: playlist['description'],
      youtube_id: playlist['_links']['makigas:youtube']['href'].gsub('https://youtube.com/playlist?list=', ''),
      card: get_icon_url_by_size(playlist['_links']['makigas:card'], '1280x720'),
      thumbnail: get_icon_url_by_size(playlist['_links']['icon'], '720x720') }
  end

  def upsert_topic(topic)
    @topics[topic['slug']] ||= Topic.find_or_initialize_by(slug: topic['slug']).tap do |t|
      t.update(topic_attributes(topic))
    end
  end

  def topic_attributes(topic)
    { title: topic['title'],
      description: topic['description'],
      color: topic['color'],
      thumbnail: get_icon_url_by_size(topic.dig('_links', 'icon'), '720x720') }
  end

  def get_icon_url_by_size(icons, size)
    icons.find { |icon| icon['sizes'].include?(size) }['href'].split('?')[0]
  end

  def recursive_fetch(url, target, &)
    print '.'
    $stdout.flush

    resp = fetch(url)
    raise Net::HTTPError, 'Invalid response lacks videos[] key' if resp.body[target].blank?

    resp.body[target].each(&)
    next_video = resp.body.dig('_links', 'next', 'href')
    recursive_fetch(next_video, target, &) if next_video.present?
  end

  def fetch(url)
    url = "/#{url}" unless url.starts_with?('/')
    client.get(url).tap do |resp|
      raise Net::HTTPError, "Invalid status code: #{resp.status}" unless resp.status == 200
    end
  end

  def client
    @client ||= Faraday.new(url: ROOT_URL, headers: CLIENT_HEADERS) do |f|
      f.request :json
      f.response :json
    end
  end
end

DownloadProduction.new
