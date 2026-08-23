# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Indexer do
  before do
    allow(Video).to receive(:reindex!)
    allow(Playlist).to receive(:reindex!)
    allow(Tag).to receive(:deploy_synonyms)
  end

  it 'reindexes videos asynchronously by default' do
    described_class.reindex!

    expect(Video).to have_received(:reindex!).with(1000, false)
  end

  it 'reindexes playlists asynchronously by default' do
    described_class.reindex!

    expect(Playlist).to have_received(:reindex!).with(1000, false)
  end

  it 'deploys tag synonyms' do
    described_class.reindex!

    expect(Tag).to have_received(:deploy_synonyms)
  end

  it 'waits for index updates when requested' do
    described_class.reindex!(async: false)

    expect(Video).to have_received(:reindex!).with(1000, true)
  end
end
