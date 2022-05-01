# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideoSearch, type: :class do
  describe '#videos' do
    let(:videos) { class_double(Video).as_stubbed_const }

    before { allow(videos).to receive(:search).and_return([:outcome]) }

    it 'returns the outcome of the search' do
      service = described_class.new('java search')
      expect(service.videos).to eq [:outcome]
    end

    describe 'the query parameter' do
      it 'is forwarded to the search service' do
        described_class.new('java videos').videos
        expect(videos).to have_received(:search).with('java videos', any_args)
      end
    end

    describe 'the page parameter' do
      it 'is forwarded to the search service' do
        described_class.new('java videos', page: 3).videos
        expected_hash = { page: 3 }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end
    end

    describe 'the length filter parameter' do
      it 'translates the short videos' do
        described_class.new('java videos', filters: { length: :short }).videos
        expected_hash = { filter: array_including('duration <= 300') }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end

      it 'translates the medium videos' do
        described_class.new('java videos', filters: { length: :medium }).videos
        expected_hash = { filter: array_including('duration <= 900', 'duration > 300') }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end

      it 'translates the long videos' do
        described_class.new('java videos', filters: { length: :long }).videos
        expected_hash = { filter: array_including('duration > 900') }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end
    end

    describe 'the topics filter parameter' do
      it 'excludes topics that do not exist' do
        described_class.new('java videos', filters: { topic: %w[fake-topic] }).videos
        expected_hash = { filter: [[]] }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end

      it 'includes topics that do exist' do
        create(:topic, title: 'A real topic', slug: 'real-topic')
        described_class.new('java videos', filters: { topic: %w[real-topic] }).videos
        expected_hash = { filter: [['topic_slug = real-topic']] }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end

      it 'behaves like an OR' do
        create(:topic, title: 'A real topic', slug: 'real-topic')
        create(:topic, title: 'Another topic', slug: 'another-topic')
        described_class.new('java videos', filters: { topic: %w[real-topic another-topic fake] }).videos
        expected_hash = { filter: [['topic_slug = real-topic', 'topic_slug = another-topic']] }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end
    end

    describe 'combining multiple filters' do
      it 'merges the filters for simple cases' do
        create(:topic, title: 'Real topic', slug: 'real-topic')
        described_class.new('java videos', filters: { topic: %w[real-topic], length: :short }).videos
        expected_hash = { filter: ['duration <= 300', ['topic_slug = real-topic']] }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end

      it 'merges the filters for complex cases' do
        create(:topic, title: 'Real topic', slug: 'real-topic')
        create(:topic, title: 'Another topic', slug: 'another-topic')
        described_class.new('java videos', filters: { topic: %w[real-topic another-topic], length: :medium }).videos
        expected_hash = { filter: ['duration > 300', 'duration <= 900',
                                   ['topic_slug = real-topic', 'topic_slug = another-topic']] }
        expect(videos).to have_received(:search).with('java videos', hash_including(expected_hash))
      end
    end
  end
end
