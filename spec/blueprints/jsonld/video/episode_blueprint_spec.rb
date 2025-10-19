# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::EpisodeBlueprint do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to Time.utc(2024, 9, 15, 14, 23, 6)
  end

  let(:video) do
    create(:video, youtube_id: 'episode12345', tags: %w[ruby rails], position: 5,
                   duration: 615, created_at: 2.days.ago, published_at: 3.days.ago)
  end

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode",
        '@type' => 'Episode',
        'name' => video.title,
        'description' => video.description,
        'keywords' => %w[ruby rails],
        'dateCreated' => '2024-09-13T14:23:06Z',
        'dateModified' => '2024-09-15T14:23:06Z',
        'datePublished' => '2024-09-12T14:23:06Z',
        'thumbnailUrl' => 'https://i1.ytimg.com/vi/episode12345/maxresdefault.jpg',
        'timeRequired' => 'PT10M15S',
        'episodeNumber' => 5,
        'publisher' => {
          '@id' => 'https://www.makigas.es/#publisher'
        },
        'partOfSeries' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}#series"
        }
      }
    end

    it { is_expected.to match(shape) }

    context 'when the video has an author' do
      before do
        video.update(user:)
      end

      let(:user) { create(:user, name: 'Jane Developer', external_url: 'https://janedev.example') }

      let(:shape) do
        {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode",
          '@type' => 'Episode',
          'name' => video.title,
          'description' => video.description,
          'keywords' => %w[ruby rails],
          'dateCreated' => '2024-09-13T14:23:06Z',
          'dateModified' => '2024-09-15T14:23:06Z',
          'datePublished' => '2024-09-12T14:23:06Z',
          'thumbnailUrl' => 'https://i1.ytimg.com/vi/episode12345/maxresdefault.jpg',
          'timeRequired' => 'PT10M15S',
          'episodeNumber' => 5,
          'author' => {
            '@id' => "https://www.makigas.es/users/#{user.id}#author"
          },
          'publisher' => {
            '@id' => 'https://www.makigas.es/#publisher'
          },
          'partOfSeries' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}#series"
          }
        }
      end

      it { is_expected.to match(shape) }
    end
  end
end
