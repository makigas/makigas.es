# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'factories' do
    context 'when using :video' do
      it 'is valid' do
        video = build(:video)
        expect(video).to be_valid
      end
    end

    context 'when using :yesterday_video' do
      it 'is valid' do
        video = build(:yesterday_video)
        expect(video).to be_valid
      end
    end

    context 'when using :tomorrow_video' do
      it 'is valid' do
        video = build(:tomorrow_video)
        expect(video).to be_valid
      end
    end
  end

  describe 'relationships' do
    it 'has links' do
      video = build(:video)
      expect(video).to respond_to(:links)
    end
  end

  describe 'validation' do
    it 'is not valid without title' do
      video = build(:video, title: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long title' do
      video = build(:video, title: 'A' * 101)
      expect(video).not_to be_valid
    end

    it 'is not valid without description' do
      video = build(:video, description: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a long description' do
      video = build(:video, description: 'A' * 1501)
      expect(video).not_to be_valid
    end

    it 'is not valid without YouTube ID' do
      video = build(:video, youtube_id: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long YouTube ID' do
      video = build(:video, youtube_id: 'A' * 16)
      expect(video).not_to be_valid
    end

    it 'is not valid without duration' do
      video = build(:video, duration: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with zero duration' do
      video = build(:video, duration: 0)
      expect(video).not_to be_valid
    end

    it 'is not valid with negative duration' do
      video = build(:video, duration: -1)
      expect(video).not_to be_valid
    end

    it 'is not valid without being in a playlist' do
      video = build(:video, playlist: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a publishing date' do
      video = build(:video, published_at: nil)
      expect(video).not_to be_valid
    end
  end

  describe '#slug' do
    it 'generates slug' do
      video = create(:video, title: 'Sample')
      expect(video.slug).to eq 'sample'
    end

    it 'does not repeat slug' do
      playlist = create(:playlist)
      video1 = create(:video, title: 'Sample', playlist: playlist)
      video2 = create(:video, title: 'Sample', youtube_id: 'AAAA', playlist: playlist)
      expect(video1.slug).not_to eq video2.slug
    end

    it 'repeats slug on different playlists' do
      video1 = create(:video, title: 'Sample', youtube_id: 'AAAA')
      playlist2 = create(:playlist, title: 'Hello')
      video2 = create(:video, title: 'Sample', playlist: playlist2)
      expect(video1.slug).to eq video2.slug
    end
  end

  describe '#natural_duration' do
    let(:playlist) { create(:playlist) }

    describe 'converts from duration to natural duration' do
      it { expect(build(:video, playlist: playlist, duration: 12).natural_duration).to eq '00:00:12' }
      it { expect(build(:video, playlist: playlist, duration: 61).natural_duration).to eq '00:01:01' }
      it { expect(build(:video, playlist: playlist, duration: 102).natural_duration).to eq '00:01:42' }
      it { expect(build(:video, playlist: playlist, duration: 3600).natural_duration).to eq '01:00:00' }
    end

    describe 'converts from natural duration to duration' do
      it { expect(build(:video, playlist: playlist, natural_duration: '0:12').duration).to eq 12 }
      it { expect(build(:video, playlist: playlist, natural_duration: '1:01').duration).to eq 61 }
      it { expect(build(:video, playlist: playlist, natural_duration: '1:42').duration).to eq 102 }
      it { expect(build(:video, playlist: playlist, natural_duration: '59:59').duration).to eq 3599 }
      it { expect(build(:video, playlist: playlist, natural_duration: '1:00:00').duration).to eq 3600 }
      it { expect(build(:video, playlist: playlist, natural_duration: '9:59:59').duration).to eq 35_999 }
      it { expect(build(:video, playlist: playlist, natural_duration: '10:00:00').duration).to eq 36_000 }
    end
  end

  describe '.visible?' do
    let(:published) { build(:video, published_at: 2.days.ago) }
    let(:scheduled) { build(:video, published_at: 6.weeks.from_now) }

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
    let(:published) { build(:video, published_at: 2.days.ago) }
    let(:scheduled) { build(:video, published_at: 6.weeks.from_now) }

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
      published = create(:video, youtube_id: 'ASDF', published_at: 2.days.ago)
      videos = described_class.visible.collect
      expect(videos).to include published
    end

    it 'does not contain a video published tomorrow' do
      scheduled = create(:video, youtube_id: 'ASDQ', published_at: 2.days.from_now)
      videos = described_class.visible.collect
      expect(videos).not_to include scheduled
    end
  end

  describe '.filter_by_tag' do
    it 'filters by tag' do
      create(:video, youtube_id: '11223344', tags: [])
      v2 = create(:video, youtube_id: '11223355', tags: ['python'])
      expect(described_class.filter_by_tag('python')).to match [v2]
    end

    it 'filters by multiple tags' do
      create(:video, youtube_id: '11223344', tags: ['python'])
      v2 = create(:video, youtube_id: '11223355', tags: %w[python django])
      expect(described_class.filter_by_tag(%w[python django])).to match [v2]
    end
  end

  describe '.tags' do
    it 'returns all the available tags' do
      create(:video, youtube_id: '11223344', tags: %w[python ruby])
      create(:video, youtube_id: '11223355', tags: %w[ruby git])
      expect(described_class.tags).to match_array %w[python git ruby]
    end
  end
end
