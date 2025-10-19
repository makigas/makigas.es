# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::PlaylistBlueprint do
  subject(:schema) { described_class.render_as_hash(playlist, host: 'https://www.makigas.es') }

  let(:playlist) do
    create(:playlist).tap do |playlist|
      create(:video, playlist:)
    end
  end

  let(:shape) do
    {
      '@context' => 'https://schema.org/',
      '@graph' => an_object_matching(
        [
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{playlist.slug}#publisher" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{playlist.slug}#webpage" }),
          a_hash_including({ '@id' => "https://www.makigas.es/series/#{playlist.slug}#series" })
        ]
      )
    }
  end

  it { is_expected.to match(shape) }
end
