# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Paginator, type: :class do
  describe '#first_page?' do
    subject { paginator.first_page? }

    describe 'when is actually the first page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 1) }

      it { is_expected.to be true }
    end

    describe 'when is not the first page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 3) }

      it { is_expected.to be false }
    end
  end

  describe '#last_page?' do
    subject { paginator.last_page? }

    describe 'when is actually the last page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 5) }

      it { is_expected.to be true }
    end

    describe 'when is not the last page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 3) }

      it { is_expected.to be false }
    end
  end

  describe '#prev_page' do
    subject { paginator.prev_page }

    describe 'when is the first page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 1) }

      it { is_expected.to be_nil }
    end

    describe 'when is not the first page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 3) }

      it { is_expected.to be 2 }
    end
  end

  describe '#next_page' do
    subject { paginator.next_page }

    describe 'when is the last page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 5) }

      it { is_expected.to be_nil }
    end

    describe 'when is not the last page' do
      let(:paginator) { described_class.new(total_pages: 5, page: 3) }

      it { is_expected.to be 4 }
    end
  end

  describe '#page_range' do
    subject { paginator.page_range.to_a }

    describe 'for the first page' do
      let(:paginator) { described_class.new(total_pages: 15, page: 1) }

      it { is_expected.to eq [1, 2, 3, 4, 5, 6, 7] }
    end

    describe 'for the last page of the left edge' do
      let(:paginator) { described_class.new(total_pages: 15, page: 4) }

      it { is_expected.to eq [1, 2, 3, 4, 5, 6, 7] }
    end

    describe 'for the first page after the left edge' do
      let(:paginator) { described_class.new(total_pages: 15, page: 5) }

      it { is_expected.to eq [2, 3, 4, 5, 6, 7, 8] }
    end

    describe 'can paginate' do
      let(:paginator) { described_class.new(total_pages: 20, page: 10) }

      it { is_expected.to eq [7, 8, 9, 10, 11, 12, 13] }
    end

    describe 'for the last page before the right edge' do
      let(:paginator) { described_class.new(total_pages: 15, page: 11) }

      it { is_expected.to eq [8, 9, 10, 11, 12, 13, 14] }
    end

    describe 'for the first page in the right edge' do
      let(:paginator) { described_class.new(total_pages: 15, page: 12) }

      it { is_expected.to eq [9, 10, 11, 12, 13, 14, 15] }
    end

    describe 'for the last page' do
      let(:paginator) { described_class.new(total_pages: 15, page: 15) }

      it { is_expected.to eq [9, 10, 11, 12, 13, 14, 15] }
    end

    describe 'the left edge when the pagination range is changed' do
      let(:paginator) { described_class.new(total_pages: 15, page: 1, pagination_range: 5) }

      it { is_expected.to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] }
    end

    describe 'the center edge when the pagination range is changed' do
      let(:paginator) { described_class.new(total_pages: 20, page: 10, pagination_range: 5) }

      it { is_expected.to eq [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] }
    end

    describe 'the right edge when the pagination range is changed' do
      let(:paginator) { described_class.new(total_pages: 20, page: 20, pagination_range: 5) }

      it { is_expected.to eq [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20] }
    end
  end
end
