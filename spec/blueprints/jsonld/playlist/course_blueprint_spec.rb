# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Playlist::CourseBlueprint do
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
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#course"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(playlist, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#course",
        '@type' => 'Course',
        'name' => playlist.title,
        'description' => playlist.description,
        'url' => "https://www.makigas.es/series/#{playlist.slug}",
        'inLanguage' => 'es',
        'isAccessibleForFree' => true,
        'provider' => {
          '@id' => 'https://www.makigas.es/#publisher'
        },
        'hasPart' => [
          {
            '@id' => "https://www.makigas.es/series/#{playlist.slug}/#{playlist.videos.first.slug}#lesson"
          },
          {
            '@id' => "https://www.makigas.es/series/#{playlist.slug}/#{playlist.videos.last.slug}#lesson"
          }
        ]
      }
    end

    it { is_expected.to match(shape) }
  end
end
