# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::Video::AuthorBlueprint do
  let(:host) { 'https://www.makigas.es' }
  let(:user) { create(:user, name: 'Jane Developer', external_url: 'https://janedev.example') }
  let(:video) { create(:video, user:, title: 'Understanding JSON-LD') }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(video, host:) }

    let(:shape) do
      {
        '@id' => "#{host}/series/#{video.playlist.slug}/#{video.slug}#author"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(video, view: :full, host:) }

    let(:shape) do
      {
        '@id' => "#{host}/series/#{video.playlist.slug}/#{video.slug}#author",
        '@type' => 'Person',
        'name' => user.name,
        'url' => user.external_url
      }
    end

    it { is_expected.to match(shape) }
  end
end
