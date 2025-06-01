# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::QueryParamsSerializer, type: :class do
  subject { described_class.convert(filters) }

  let(:filters) { Search::Filters.new(params).tap(&:clean!) }

  describe 'default casting' do
    let(:params) { {} }

    it { is_expected.to be_empty }
  end

  describe 'query' do
    describe 'is casted' do
      let(:params) { { query: 'install java' } }

      it { is_expected.to eq({ 'q' => 'install java' }) }
    end
  end

  describe 'tag' do
    describe 'is casted' do
      let(:params) { { tag: 'java' } }

      it { is_expected.to eq({ 'tag' => 'java' }) }
    end
  end

  describe 'page number' do
    describe 'is casted' do
      let(:params) { { page: 4 } }

      it { is_expected.to eq({ 'pagina' => 4 }) }
    end

    describe 'fallbacks to default' do
      let(:params) { { page: -2 } }

      it { is_expected.to eq({}) }
    end
  end

  describe 'content type' do
    describe 'is casted' do
      let(:params) { { content_type: :playlists } }

      it { is_expected.to eq({ 'type' => 'cursos' }) }
    end

    describe 'fallbacks to default' do
      let(:params) { { content_type: :skittles } }

      it { is_expected.to eq({}) }
    end
  end

  describe 'sort' do
    describe 'is casted' do
      let(:params) { { sort: :trending } }

      it { is_expected.to eq({ 'orden' => 'tendencia' }) }
    end

    describe 'fallbacks to default' do
      let(:params) { { sort: :votes } }

      it { is_expected.to eq({}) }
    end
  end

  describe 'filter obsolete' do
    describe 'included if true' do
      let(:params) { { exclude_obsolete: true } }

      it { is_expected.to eq({ 'sin-obsoletos' => '1' }) }
    end

    describe 'excluded if null' do
      let(:params) { { exclude_obsolete: nil } }

      it { is_expected.to eq({}) }
    end

    describe 'excluded if false' do
      let(:params) { { exclude_obsolete: false } }

      it { is_expected.to eq({}) }
    end
  end

  describe 'filter content without article' do
    describe 'included if present' do
      let(:params) { { articles: true } }

      it { is_expected.to eq({ 'articulos' => '1' }) }
    end

    describe 'excluded if null' do
      let(:params) { { articles: nil } }

      it { is_expected.to eq({}) }
    end

    describe 'excluded if false' do
      let(:params) { { articles: false } }

      it { is_expected.to eq({}) }
    end
  end
end
