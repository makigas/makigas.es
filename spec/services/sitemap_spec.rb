# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sitemap do
  describe '.fingerprint' do
    it 'changes when a video is created' do
      revision = described_class.fingerprint.revision

      create(:yesterday_video)

      expect(described_class.fingerprint.revision).not_to eq revision
    end

    it 'changes when a video is updated' do
      video = create(:yesterday_video)
      revision = described_class.fingerprint.revision

      video.update!(title: 'A different title', updated_at: 1.minute.from_now)

      expect(described_class.fingerprint.revision).not_to eq revision
    end

    it 'changes when a playlist is updated' do
      playlist = create(:playlist)
      revision = described_class.fingerprint.revision

      playlist.update!(title: 'A different title', updated_at: 1.minute.from_now)

      expect(described_class.fingerprint.revision).not_to eq revision
    end

    it 'uses the most recent update as the last modification date' do
      video = create(:yesterday_video)

      expect(described_class.fingerprint.last_modified).to be_within(0.000001).of(video.updated_at)
    end
  end

  describe '.xml' do
    before do
      allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
    end

    it 'reuses the cached document for the same content' do
      builder = instance_double(Proc, call: '<xml/>')

      described_class.xml { builder.call }
      described_class.xml { builder.call }

      expect(builder).to have_received(:call).once
    end

    it 'rebuilds the document when the content changes', :aggregate_failures do
      builder = instance_double(Proc, call: '<xml/>')
      described_class.xml { builder.call }
      revision = described_class.fingerprint.revision

      create(:yesterday_video)
      described_class.xml { builder.call }

      expect(described_class.fingerprint.revision).not_to eq revision
      expect(builder).to have_received(:call).twice
    end
  end
end
