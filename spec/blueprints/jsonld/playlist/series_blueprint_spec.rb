# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Playlist::SeriesBlueprint do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to Time.utc(2024, 9, 15, 14, 23, 6)
  end

  let(:playlist) do
    create(:playlist).tap do |playlist|
      create(:video, playlist:, published_at: 3.days.ago, tags: %w[java records])
      create(:video, playlist:, published_at: 2.days.ago, tags: %w[java maps])
    end
  end

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(playlist, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#series"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(playlist, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#series",
        '@type' => 'CreativeWorkSeries',
        'name' => playlist.title,
        'description' => playlist.description,
        'abstract' => playlist.description,
        'dateCreated' => '2024-09-15T14:23:06Z',
        'dateModified' => '2024-09-15T14:23:06Z',
        'datePublished' => '2024-09-12T14:23:06Z',
        'keywords' => %w[java maps records],
        'thumbnailUrl' => Rails.application.routes.url_helpers.rails_representation_url(
          playlist.thumbnail_variant(:default), host: 'https://www.makigas.es'
        ),
        'image' => Rails.application.routes.url_helpers.rails_representation_url(
          playlist.card_variant(:default), host: 'https://www.makigas.es'
        ),
        'publisher' => {
          '@id' => 'https://www.makigas.es/#publisher'
        },
        'url' => "https://www.makigas.es/series/#{playlist.slug}",
        'sameAs' => "https://www.youtube.com/playlist?list=#{playlist.youtube_id}"
      }
    end

    it { is_expected.to match(shape) }
  end
end
