# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebuildSearchIndexJob do
  before do
    allow(Search::Indexer).to receive(:reindex!)
  end

  it 'rebuilds the search index' do
    described_class.perform_now

    expect(Search::Indexer).to have_received(:reindex!)
  end
end
