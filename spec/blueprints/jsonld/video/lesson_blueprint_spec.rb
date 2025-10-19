# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::LessonBlueprint do
  include ActiveSupport::Testing::TimeHelpers

  before do
    travel_to Time.utc(2024, 9, 15, 14, 23, 6)
  end

  let(:video) { create(:video, published_at: 2.days.ago, duration: 352) }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#lesson"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#lesson",
        '@type' => 'CreativeWork',
        'learningResourceType' => 'Lesson',
        'url' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}",
        'name' => video.title,
        'description' => video.description,
        'position' => video.position,
        'timeRequired' => 'PT5M52S',
        'isPartOf' => {
          '@id' => "https://www.makigas.es/series/#{video.playlist.slug}#course"
        }
      }
    end

    it { is_expected.to match(shape) }
  end
end
