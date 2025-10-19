# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::PublisherBlueprint do
  let(:video) { create(:video) }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#publisher",
        '@type' => 'Organization',
        'name' => 'Makigas',
        'url' => 'https://www.makigas.es'
      }
    end

    it { is_expected.to match(shape) }
  end
end
