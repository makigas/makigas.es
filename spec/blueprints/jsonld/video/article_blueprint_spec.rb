# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::ArticleBlueprint do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to Time.utc(2024, 9, 15, 14, 23, 6)
  end

  let(:video) { create(:video, published_at: 2.days.ago) }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#article"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#article",
        '@type' => 'TechArticle',
        'headline' => video.title,
        'dateModified' => '2024-09-15T14:23:06Z',
        'datePublished' => '2024-09-13T14:23:06Z',
        'publisher' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher"
        },
        'image' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail"
        },
        'associatedMedia' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video"
        }
      }
    end

    it { is_expected.to match(shape) }

    context 'when the video has an user' do
      let(:user) { create(:user) }
      let(:video) { create(:video, user:, published_at: 2.days.ago) }

      let(:shape) do
        {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#article",
          '@type' => 'TechArticle',
          'headline' => video.title,
          'dateModified' => '2024-09-15T14:23:06Z',
          'datePublished' => '2024-09-13T14:23:06Z',
          'author' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#author"
          },
          'publisher' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher"
          },
          'image' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail"
          },
          'associatedMedia' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video"
          }
        }
      end

      it { is_expected.to match(shape) }
    end
  end
end
