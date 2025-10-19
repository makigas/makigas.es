# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::SeriesBlueprint do
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

  let(:video) { playlist.videos.last }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#series"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#series",
        '@type' => 'CreativeWorkSeries',
        'name' => video.playlist.title,
        'description' => video.playlist.description,
        'abstract' => video.playlist.description,
        'dateCreated' => '2024-09-15T14:23:06Z',
        'dateModified' => '2024-09-15T14:23:06Z',
        'datePublished' => '2024-09-12T14:23:06Z',
        'keywords' => %w[java maps records],
        'thumbnailUrl' => video.playlist.thumbnail.url(:thumb),
        'image' => video.playlist.card.url(:thumb),
        'publisher' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher"
        },
        'url' => "https://www.makigas.es/series/#{video.playlist.slug}",
        'sameAs' => "https://www.youtube.com/playlist?list=#{playlist.youtube_id}"
      }
    end

    it { is_expected.to match(shape) }

    context 'when the video has an user' do
      before do
        playlist.videos.update(user:)
      end

      let(:user) { create(:user) }

      let(:shape) do
        {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#series",
          '@type' => 'CreativeWorkSeries',
          'name' => video.playlist.title,
          'description' => video.playlist.description,
          'abstract' => video.playlist.description,
          'dateCreated' => '2024-09-15T14:23:06Z',
          'dateModified' => '2024-09-15T14:23:06Z',
          'datePublished' => '2024-09-12T14:23:06Z',
          'keywords' => %w[java maps records],
          'thumbnailUrl' => video.playlist.thumbnail.url(:thumb),
          'image' => video.playlist.card.url(:thumb),
          'author' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#author"
          },
          'publisher' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher"
          },
          'url' => "https://www.makigas.es/series/#{video.playlist.slug}",
          'sameAs' => "https://www.youtube.com/playlist?list=#{playlist.youtube_id}"
        }
      end

      it { is_expected.to match(shape) }
    end
  end
end
