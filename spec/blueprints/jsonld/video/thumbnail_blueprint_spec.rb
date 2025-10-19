# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::ThumbnailBlueprint do
  let(:video) { create(:video, youtube_id: 'thumb123abc45') }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/series/#{video.playlist.slug}/#{video.slug}#thumbnail",
        '@type' => 'ImageObject',
        'url' => 'https://i1.ytimg.com/vi/thumb123abc45/maxresdefault.jpg'
      }
    end

    it { is_expected.to match(shape) }
  end
end
