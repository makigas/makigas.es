# frozen_string_literal: true

module Sitemap
  HOST = 'https://www.makigas.es'
  CACHE_TTL = 1.day
  PROXY_CACHE_TTL = 5.minutes

  Fingerprint = Data.define(:videos_updated_at, :videos_count, :playlists_updated_at, :playlists_count) do
    def revision
      Digest::SHA256.hexdigest(
        [videos_updated_at, videos_count, playlists_updated_at, playlists_count].join(':')
      )
    end

    def last_modified
      [videos_updated_at, playlists_updated_at].compact.max || Time.zone.at(0)
    end
  end

  class << self
    def fingerprint
      Fingerprint.new(
        videos_updated_at: Video.maximum(:updated_at),
        videos_count: Video.count,
        playlists_updated_at: Playlist.maximum(:updated_at),
        playlists_count: Playlist.count
      )
    end

    def xml(fingerprint = self.fingerprint, &)
      Rails.cache.fetch("sitemap/#{fingerprint.revision}", expires_in: CACHE_TTL, &)
    end
  end
end
