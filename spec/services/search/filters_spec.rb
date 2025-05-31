# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Filters, type: :class do
  describe 'attribute assignment and validation' do
    subject { described_class.new }

    let(:attributes) do
      { query: nil, page: 1, per_page: 20,
        content_type: nil, sort: nil, exclude_obsolete: false,
        articles: false }
    end

    it { is_expected.to have_attributes(attributes) }
    it { is_expected.to be_valid }

    describe 'when there are additional parameters set' do
      subject { described_class.new(params) }

      let(:params) do
        { 'query' => 'install java', 'page' => '2', 'per_page' => '15',
          'content_type' => 'videos', 'sort' => 'trending',
          'exclude_obsolete' => true, 'articles' => true }
      end

      let(:attributes) do
        { query: 'install java', page: 2, per_page: 15, content_type: :videos,
          sort: :trending, exclude_obsolete: true, articles: true }
      end

      it { is_expected.to have_attributes(attributes) }

      it { is_expected.to be_valid }
    end

    describe 'validates negative page numbers' do
      subject { described_class.new(page: -2) }

      it { is_expected.not_to be_valid }
    end

    describe 'validates zero page numbers' do
      subject { described_class.new(page: 0) }

      it { is_expected.not_to be_valid }
    end

    describe 'validate negative per page number' do
      subject { described_class.new(per_page: -2) }

      it { is_expected.not_to be_valid }
    end

    describe 'validate zero per page number' do
      subject { described_class.new(per_page: 0) }

      it { is_expected.not_to be_valid }
    end

    describe 'validate unacceptable content type' do
      subject { described_class.new(content_type: 'fridge') }

      it { is_expected.not_to be_valid }
    end

    describe 'validate unacceptable sort criteria' do
      subject { described_class.new(sort: 'skittles') }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#clean' do
    describe 'when an invalid page number is given' do
      subject(:form) { described_class.new(page: -2) }

      before { form.clean! }

      it { is_expected.to have_attributes(page: 1) }
    end

    describe 'when an invalid per page number is given' do
      subject(:form) { described_class.new(per_page: -2) }

      before { form.clean! }

      it { is_expected.to have_attributes(per_page: 20) }
    end

    describe 'when an invalid content type criteria is given' do
      subject(:form) { described_class.new(content_type: 'fridge') }

      before { form.clean! }

      it { is_expected.to have_attributes(content_type: nil) }
    end

    describe 'when an invalid sort criteria is given' do
      subject(:form) { described_class.new(sort: 'skittles') }

      before { form.clean! }

      it { is_expected.to have_attributes(sort: nil) }
    end
  end
end
