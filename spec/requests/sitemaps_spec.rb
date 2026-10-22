# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sitemap' do
  let(:playlist) { create(:playlist) }
  let!(:video) { create(:yesterday_video, playlist: playlist) }

  describe 'GET /sitemap.xml' do
    before { get '/sitemap.xml' }

    it 'returns an XML sitemap', :aggregate_failures do
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq 'application/xml'
    end

    it 'contains the canonical URLs', :aggregate_failures do
      document = Nokogiri::XML(response.body)
      locations = document
                  .xpath('//xmlns:url/xmlns:loc', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9')
                  .map(&:text)

      expect(locations).to include(
        'https://www.makigas.es/',
        'https://www.makigas.es/series',
        "https://www.makigas.es/series/#{playlist.slug}",
        "https://www.makigas.es/series/#{playlist.slug}/#{video.slug}",
        'https://www.makigas.es/terminos',
        'https://www.makigas.es/privacidad',
        'https://www.makigas.es/cookies',
        'https://www.makigas.es/responsabilidades'
      )
    end

    it 'does not list videos that are not published yet' do
      unpublished = create(:tomorrow_video, playlist: playlist)

      get '/sitemap.xml'

      expect(response.body).not_to include unpublished.slug
    end

    it 'allows public caching for five minutes', :aggregate_failures do
      expect(response.headers['ETag']).to be_present
      expect(response.headers['Cache-Control']).to include('public', 'max-age=300')
    end

    it 'returns not modified when the client has the current version' do
      etag = response.headers['ETag']
      get '/sitemap.xml', headers: { 'If-None-Match' => etag }

      expect(response).to have_http_status(:not_modified)
    end
  end
end
