# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::QueryParamsDeserializer, type: :class do
  subject { described_class.convert(params) }

  describe 'query' do
    describe 'is casted' do
      let(:params) { { 'q' => 'install java' } }

      it { is_expected.to have_attributes(query: 'install java') }
    end

    describe 'fallbacks when not present' do
      let(:params) { {} }

      it { is_expected.to have_attributes(query: nil) }
    end
  end

  describe 'page number' do
    describe 'is casted from number' do
      let(:params) { { 'pagina' => 4 } }

      it { is_expected.to have_attributes(page: 4) }
    end

    describe 'is casted from string' do
      let(:params) { { 'pagina' => '4' } }

      it { is_expected.to have_attributes(page: 4) }
    end

    describe 'fallbacks when invalid value' do
      let(:params) { { 'pagina' => -2 } }

      it { is_expected.to have_attributes(page: 1) }
    end

    describe 'fallbacks when invalid type' do
      let(:params) { { 'pagina' => 'number' } }

      it { is_expected.to have_attributes(page: 1) }
    end
  end

  describe 'type' do
    describe 'casts when valid' do
      let(:params) { { 'type' => 'cursos' } }

      it { is_expected.to have_attributes(content_type: :playlists) }
    end

    describe 'fallbacks when invalid' do
      let(:params) { { 'type' => 'pingüino' } }

      it { is_expected.to have_attributes(content_type: nil) }
    end

    describe 'fallbacks when not present' do
      let(:params) { {} }

      it { is_expected.to have_attributes(content_type: nil) }
    end
  end

  describe 'sort criteria' do
    describe 'casts when valid' do
      let(:params) { { 'orden' => 'tendencia' } }

      it { is_expected.to have_attributes(sort: :trending) }
    end

    describe 'fallbacks when invalid' do
      let(:params) { { 'orden' => 'color' } }

      it { is_expected.to have_attributes(sort: nil) }
    end

    describe 'fallbacks when not present' do
      let(:params) { {} }

      it { is_expected.to have_attributes(sort: nil) }
    end
  end

  describe 'exclude obsolete' do
    describe 'casts when present' do
      let(:params) { { 'sin-obsoletos' => '1' } }

      it { is_expected.to have_attributes(exclude_obsolete: true) }
    end

    describe 'fallbacks when absent' do
      let(:params) { { 'sin-obsoletos' => '' } }

      it { is_expected.to have_attributes(exclude_obsolete: false) }
    end

    describe 'fallbacks when not present' do
      let(:params) { {} }

      it { is_expected.to have_attributes(exclude_obsolete: false) }
    end
  end

  describe 'only articles' do
    describe 'casts when present' do
      let(:params) { { 'articulos' => '1' } }

      it { is_expected.to have_attributes(articles: true) }
    end

    describe 'fallbacks when absent' do
      let(:params) { { 'articulos' => '' } }

      it { is_expected.to have_attributes(articles: false) }
    end

    describe 'fallbacks when not present' do
      let(:params) { {} }

      it { is_expected.to have_attributes(articles: false) }
    end
  end
end
