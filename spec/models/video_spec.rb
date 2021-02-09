# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'factories' do
    context 'when using :video' do
      it 'is valid' do
        video = FactoryBot.build(:video)
        expect(video).to be_valid
      end
    end

    context 'when using :yesterday_video' do
      it 'is valid' do
        video = FactoryBot.build(:yesterday_video)
        expect(video).to be_valid
      end
    end

    context 'when using :tomorrow_video' do
      it 'is valid' do
        video = FactoryBot.build(:tomorrow_video)
        expect(video).to be_valid
      end
    end
  end

  describe 'relationships' do
    it 'has links' do
      video = FactoryBot.build(:video)
      expect(video).to respond_to(:links)
    end
  end

  describe 'validation' do
    it 'is not valid without title' do
      video = FactoryBot.build(:video, title: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long title' do
      video = FactoryBot.build(:video, title: 'A' * 101)
      expect(video).not_to be_valid
    end

    it 'is not valid without description' do
      video = FactoryBot.build(:video, description: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a long description' do
      video = FactoryBot.build(:video, description: 'A' * 1501)
      expect(video).not_to be_valid
    end

    it 'is not valid without YouTube ID' do
      video = FactoryBot.build(:video, youtube_id: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long YouTube ID' do
      video = FactoryBot.build(:video, youtube_id: 'A' * 16)
      expect(video).not_to be_valid
    end

    it 'is not valid without duration' do
      video = FactoryBot.build(:video, duration: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with zero duration' do
      video = FactoryBot.build(:video, duration: 0)
      expect(video).not_to be_valid
    end

    it 'is not valid with negative duration' do
      video = FactoryBot.build(:video, duration: -1)
      expect(video).not_to be_valid
    end

    it 'is not valid without being in a playlist' do
      video = FactoryBot.build(:video, playlist: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a publishing date' do
      video = FactoryBot.build(:video, published_at: nil)
      expect(video).not_to be_valid
    end
  end

  describe '#slug' do
    it 'generates slug' do
      video = FactoryBot.create(:video, title: 'Sample')
      expect(video.slug).to eq 'sample'
    end

    it 'does not repeat slug' do
      playlist = FactoryBot.create(:playlist)
      video1 = FactoryBot.create(:video, title: 'Sample', playlist: playlist)
      video2 = FactoryBot.create(:video, title: 'Sample', youtube_id: 'AAAA', playlist: playlist)
      expect(video1.slug).not_to eq video2.slug
    end

    it 'repeats slug on different playlists' do
      video1 = FactoryBot.create(:video, title: 'Sample', youtube_id: 'AAAA')
      playlist2 = FactoryBot.create(:playlist, title: 'Hello')
      video2 = FactoryBot.create(:video, title: 'Sample', playlist: playlist2)
      expect(video1.slug).to eq video2.slug
    end
  end

  describe '#natural_duration' do
    describe 'converts from duration to natural duration' do
      it { expect(FactoryBot.build(:video, duration: 12).natural_duration).to eq '00:00:12' }
      it { expect(FactoryBot.build(:video, duration: 61).natural_duration).to eq '00:01:01' }
      it { expect(FactoryBot.build(:video, duration: 102).natural_duration).to eq '00:01:42' }
      it { expect(FactoryBot.build(:video, duration: 3600).natural_duration).to eq '01:00:00' }
    end

    describe 'converts from natural duration to duration' do
      it { expect(FactoryBot.build(:video, natural_duration: '0:12').duration).to eq 12 }
      it { expect(FactoryBot.build(:video, natural_duration: '1:01').duration).to eq 61 }
      it { expect(FactoryBot.build(:video, natural_duration: '1:42').duration).to eq 102 }
      it { expect(FactoryBot.build(:video, natural_duration: '59:59').duration).to eq 3599 }
      it { expect(FactoryBot.build(:video, natural_duration: '1:00:00').duration).to eq 3600 }
      it { expect(FactoryBot.build(:video, natural_duration: '9:59:59').duration).to eq 35_999 }
      it { expect(FactoryBot.build(:video, natural_duration: '10:00:00').duration).to eq 36_000 }
    end
  end

  describe '.visible?' do
    let(:published) { FactoryBot.build(:video, published_at: 2.days.ago) }
    let(:scheduled) { FactoryBot.build(:video, published_at: 6.weeks.from_now) }

    context 'when publishing date has been reached' do
      subject { published.visible? }

      it { is_expected.to eq true }
    end

    context 'when publishing date has not been reached' do
      subject { scheduled.visible? }

      it { is_expected.to eq false }
    end
  end

  describe '.scheduled?' do
    let(:published) { FactoryBot.build(:video, published_at: 2.days.ago) }
    let(:scheduled) { FactoryBot.build(:video, published_at: 6.weeks.from_now) }

    context 'when publishing date has been reached' do
      subject { published.scheduled? }

      it { is_expected.to eq false }
    end

    context 'when publishing date has not been reached' do
      subject { scheduled.scheduled? }

      it { is_expected.to eq true }
    end
  end

  describe '.visible' do
    it 'contains a video published yesterday' do
      published = FactoryBot.create(:video, youtube_id: 'ASDF', published_at: 2.days.ago)
      videos = described_class.visible.collect
      expect(videos).to include published
    end

    it 'does not contain a video published tomorrow' do
      scheduled = FactoryBot.create(:video, youtube_id: 'ASDQ', published_at: 2.days.from_now)
      videos = described_class.visible.collect
      expect(videos).not_to include scheduled
    end
  end
end
