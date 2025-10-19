# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::VideoObjectBlueprint do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to Time.utc(2024, 9, 15, 14, 23, 6)
  end

  let(:video) { create(:video, published_at: 2.days.ago, duration: 352) }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video",
        '@type' => 'VideoObject',
        'sameAs' => "https://www.youtube.com/watch?v=#{video.youtube_id}",
        'name' => video.title,
        'description' => video.description,
        'thumbnailUrl' => "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg",
        'uploadDate' => '2024-09-13T14:23:06Z',
        'duration' => 'PT5M52S',
        'embedUrl' => "https://www.youtube.com/embed/#{video.youtube_id}",
        'url' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}",
        'encodesCreativeWork' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode"
        }
      }
    end

    it { is_expected.to match(shape) }

    context 'when the video has an user' do
      before do
        video.update(user:)
      end

      let(:user) { create(:user) }
      let(:shape) do
        {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#video",
          '@type' => 'VideoObject',
          'sameAs' => "https://www.youtube.com/watch?v=#{video.youtube_id}",
          'name' => video.title,
          'description' => video.description,
          'thumbnailUrl' => "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg",
          'uploadDate' => '2024-09-13T14:23:06Z',
          'duration' => 'PT5M52S',
          'embedUrl' => "https://www.youtube.com/embed/#{video.youtube_id}",
          'url' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}",
          'encodesCreativeWork' => {
            '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#episode"
          },
          'author' => {
            '@id' => "https://www.makigas.es/users/#{user.id}#author"
          }
        }
      end

      it { is_expected.to match(shape) }
    end
  end
end
