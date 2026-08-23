# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebuildSearchIndexJob do
  let(:video_scope) { class_spy(Video) }

  before do
    allow(Video).to receive(:visible).and_return(video_scope)
    allow(Tag).to receive(:deploy_synonyms)
  end

  it 'rebuilds the video index' do
    described_class.perform_now

    expect(video_scope).to have_received(:reindex!)
  end

  it 'deploys tag synonyms' do
    described_class.perform_now

    expect(Tag).to have_received(:deploy_synonyms)
  end
end
