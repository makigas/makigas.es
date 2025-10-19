# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Playlist::PublisherBlueprint do
  let(:playlist) do
    create(:playlist).tap do |playlist|
      create(:video, playlist:)
    end
  end

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(playlist, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#publisher"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(playlist, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#publisher",
        '@type' => 'Organization',
        'name' => 'Makigas',
        'url' => 'https://www.makigas.es'
      }
    end

    it { is_expected.to match(shape) }
  end
end
