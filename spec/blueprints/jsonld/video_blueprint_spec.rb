# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::VideoBlueprint do
  subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

  let(:video) { create(:video, published_at: 2.days.ago) }

  let(:shape) do
    {
      '@context' => 'https://schema.org/',
      '@graph' => an_object_matching(
        [
          a_hash_including({ '@id' => 'https://www.makigas.es/#publisher' }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#webpage" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{video.playlist.slug}#series" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode" })
        ]
      )
    }
  end

  it { is_expected.to match(shape) }

  context 'when the video has an author' do
    before do
      video.update(user:)
    end

    let(:user) { create(:user) }

    let(:shape) do
      {
        '@context' => 'https://schema.org/',
        '@graph' => an_object_matching(
          [
            a_hash_including('@id' => 'https://www.makigas.es/#publisher'),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#webpage"),
            a_hash_including('@id' => "https://www.makigas.es/users/#{user.id}#author"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}#series"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode")

          ]
        )
      }
    end

    it { is_expected.to match(shape) }
  end

  context 'when the video has show notes' do
    let(:show_note) { create(:show_note) }

    let(:shape) do
      {
        '@context' => 'https://schema.org/',
        '@graph' => an_object_matching(
          [
            a_hash_including('@id' => 'https://www.makigas.es/#publisher'),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#webpage"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}#series"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode"),
            a_hash_including('@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#article")

          ]
        )
      }
    end

    before do
      video.update(show_note:)
    end

    it { is_expected.to match(shape) }
  end
end
