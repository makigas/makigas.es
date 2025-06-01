# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Request, type: :class do
  subject(:query) { queries.find { |query| query[:scope].name == 'Video' } }

  let(:request) { described_class.new(filters) }
  let(:queries) { request.send(:queries) }

  describe 'filter for query' do
    describe 'when present' do
      let(:filters) { Search::Filters.new(query: 'install java') }

      it 'is passed to the search engine' do
        expect(query).to include(q: 'install java')
      end
    end

    describe 'when not present' do
      let(:filters) { Search::Filters.new }

      it 'is not passed to the search engine' do
        expect(query).not_to include(:q)
      end
    end
  end

  describe 'filter for tag' do
    describe 'when present' do
      let(:filters) { Search::Filters.new(tag: 'java') }

      it 'is passed to the search engine' do
        expect(query[:filter]).to include('tags = java')
      end
    end

    describe 'when not present' do
      let(:filters) { Search::Filters.new }

      it 'is not passed to the search engine' do
        expect(query[:filter]).to be_empty
      end
    end
  end
end
