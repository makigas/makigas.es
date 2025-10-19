# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::WebpageBlueprint do
  let(:video) { create(:video, published_at: 2.days.ago) }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#webpage"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#webpage",
        '@type' => 'WebPage',
        'name' => "#{video.title} – #{video.playlist.title}",
        'description' => video.description,
        'publisher' => {
          '@id' => 'https://www.makigas.es/#publisher'
        }
      }
    end

    it { is_expected.to match(shape) }
  end
end
