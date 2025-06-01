# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Request, type: :class do
  let(:request) { described_class.new(filters) }

  describe 'federation' do
    [{ per_page: 10, page: 1, offset: 0, limit: 10 },
     { per_page: 10, page: 3, offset: 20, limit: 10 },
     { per_page: 15, page: 4, offset: 45, limit: 15 }].each do |par|
      describe "for page #{par[:page]} / #{par[:per_page]}" do
        subject(:federation) { request.send(:federation) }

        let(:filters) { Search::Filters.new(per_page: par[:per_page], page: par[:page]) }

        it 'encodes offset and limit' do
          expect(federation).to eq({ offset: par[:offset], limit: par[:limit] })
        end
      end
    end
  end

  describe 'query scopes' do
    subject(:scopes) { queries.map { |query| query[:scope].name } }

    let(:queries) { request.send(:queries) }

    describe 'when no content type is given' do
      let(:filters) { Search::Filters.new }

      it 'includes every content type' do
        expect(scopes).to contain_exactly('Video')
      end
    end

    describe 'when content_type == videos' do
      let(:filters) { Search::Filters.new(content_type: :videos) }

      it 'filters by video' do
        expect(scopes).to contain_exactly('Video')
      end
    end

    describe 'when content_type == playlists' do
      let(:filters) { Search::Filters.new(content_type: :playlists) }

      it 'filters by playlist' do
        expect(scopes).to be_empty # TODO: add filters for playlist
      end
    end
  end
end
