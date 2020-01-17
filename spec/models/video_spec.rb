require 'rails_helper'

RSpec.describe Video, type: :model do
  context 'is valid when instanciated via' do
    it ':video factory' do
      video = FactoryBot.build(:video)
      expect(video).to be_valid
    end

    it ':yesterday_video factory' do
      video = FactoryBot.build(:yesterday_video)
      expect(video).to be_valid
    end

    it ':tomorrow_video factory' do
      video = FactoryBot.build(:tomorrow_video)
      expect(video).to be_valid
    end
  end

  context 'validation' do
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

    # Note: I don't have to test whether videos are valid without position or
    # when positions are negative since apparently acts_as_list checks this.
  end

  context 'slug' do
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

  context 'natural duration' do
    it 'should convert from duration to natural duration' do
      expect(FactoryBot.build(:video, duration: 12).natural_duration).
        to eq '00:00:12'
      expect(FactoryBot.build(:video, duration: 61).natural_duration).
        to eq '00:01:01'
      expect(FactoryBot.build(:video, duration: 102).natural_duration).
        to eq '00:01:42'
      expect(FactoryBot.build(:video, duration: 3600).natural_duration).
        to eq '01:00:00'
    end

    it 'should convert from natural duration to duration' do
      video = FactoryBot.build(:video)
      video.natural_duration = '0:12'
      expect(video.duration).to eq 12
      video.natural_duration = '1:01'
      expect(video.duration).to eq 61
      video.natural_duration = '1:42'
      expect(video.duration).to eq 102
      video.natural_duration = '59:59'
      expect(video.duration).to eq 3599
      video.natural_duration = '1:00:00'
      expect(video.duration).to eq 3600
      video.natural_duration = '9:59:59'
      expect(video.duration).to eq 35_999
      video.natural_duration = '10:00:00'
      expect(video.duration).to eq 36_000
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
    before(:each) do
      @published = FactoryBot.create(:video, youtube_id: 'ASDF', published_at: 2.days.ago)
      @scheduled = FactoryBot.create(:video, youtube_id: 'ASDQ', published_at: 2.days.from_now)
    end

    it 'should contain a video published yesterday' do
      videos = Video.visible.collect
      expect(videos).to include @published
    end

    it 'should not contain a video published tomorrow' do
      videos = Video.visible.collect
      expect(videos).not_to include @scheduled
    end
  end
end
