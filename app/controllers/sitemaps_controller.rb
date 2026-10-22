# frozen_string_literal: true

class SitemapsController < ApplicationController
  def show
    fingerprint = Sitemap.fingerprint
    response.set_header('Cache-Control', "public, max-age=#{Sitemap::PROXY_CACHE_TTL.to_i}")
    return unless stale?(etag: fingerprint.revision, last_modified: fingerprint.last_modified)

    xml = Sitemap.xml(fingerprint) do
      render_to_string(template: 'sitemaps/show', formats: [:xml])
    end
    render xml: xml
  end
end
