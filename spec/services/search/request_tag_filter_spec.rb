# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Request do
  ['gcc,', 'a"b\\c', 'java'].each do |tag|
    context "with tag #{tag.inspect}" do
      let!(:matching_video) { create(:video, :published_yesterday, tags: [tag]) }

      before do
        create(:video, :published_yesterday, tags: ['unrelated'])
        Search::Indexer.reindex!(async: false)
      end

      it 'matches the literal tag in both video and playlist searches' do
        filters = Search::Filters.new(tag:)

        expect(described_class.new(filters).hits).to contain_exactly(matching_video, matching_video.playlist)
      end
    end
  end
end
