# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Playlist::WebpageBlueprint do
  let(:playlist) do
    create(:playlist).tap do |playlist|
      create(:video, playlist:)
    end
  end

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(playlist, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#webpage"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(playlist, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{playlist.slug}#webpage",
        '@type' => 'WebPage',
        'name' => "#{playlist.title} – makigas",
        'description' => playlist.description,
        'publisher' => {
          '@id' => 'https://www.makigas.es/#publisher'
        }
      }
    end

    it { is_expected.to match(shape) }
  end
end
