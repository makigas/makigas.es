require 'rails_helper'

RSpec.describe Video, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      video = FactoryGirl.build(:video)
      expect(video).to be_valid
    end

    it 'is not valid without title' do
      video = FactoryGirl.build(:video, title: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long title' do
      video = FactoryGirl.build(:video, title: 'A' * 101)
      expect(video).not_to be_valid
    end

    it 'is not valid without description' do
      video = FactoryGirl.build(:video, description: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a long description' do
      video = FactoryGirl.build(:video, description: 'A' * 1501)
      expect(video).not_to be_valid
    end

    it 'is not valid without YouTube ID' do
      video = FactoryGirl.build(:video, youtube_id: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with a long YouTube ID' do
      video = FactoryGirl.build(:video, youtube_id: 'A' * 16)
      expect(video).not_to be_valid
    end

    it 'is not valid without duration' do
      video = FactoryGirl.build(:video, duration: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with zero duration' do
      video = FactoryGirl.build(:video, duration: 0)
      expect(video).not_to be_valid
    end

    it 'is not valid with negative duration' do
      video = FactoryGirl.build(:video, duration: -1)
      expect(video).not_to be_valid
    end

    it 'is not valid without thumbnail' do
      video = FactoryGirl.build(:video, thumbnail: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without being in a playlist' do
      video = FactoryGirl.build(:video, playlist: nil)
      expect(video).not_to be_valid
    end
    
    # Note: I don't have to test whether videos are valid without position or
    # when positions are negative since apparently acts_as_list checks this.
  end

  context 'slug' do
    it 'generates slug' do
      video = FactoryGirl.create(:video, title: 'Sample')
      expect(video.slug).to eq 'sample'
    end

    it 'does not repeat slug' do
      playlist = FactoryGirl.create(:playlist)
      video1 = FactoryGirl.create(:video, title: 'Sample', playlist: playlist)
      video2 = FactoryGirl.create(:video, title: 'Sample', youtube_id: 'AAAA', playlist: playlist)
      expect(video1.slug).not_to eq video2.slug
    end

    it 'repeats slug on different playlists' do
      video1 = FactoryGirl.create(:video, title: 'Sample', youtube_id: 'AAAA')
      playlist2 = FactoryGirl.create(:playlist, title: 'Hello')
      video2 = FactoryGirl.create(:video, title: 'Sample', playlist: playlist2)
      expect(video1.slug).to eq video2.slug
    end
  end

  context 'natural duration' do
    it 'should convert from duration to natural duration' do 
      expect(FactoryGirl.build(:video, duration: 12).natural_duration).
        to eq '0:12'
      expect(FactoryGirl.build(:video, duration: 61).natural_duration).
        to eq '1:01'
      expect(FactoryGirl.build(:video, duration: 102).natural_duration).
        to eq '1:42'
      expect(FactoryGirl.build(:video, duration: 3600).natural_duration).
        to eq '1:00:00'
    end

    it 'should convert from natural duration to duration' do
      video = FactoryGirl.build(:video)
      video.natural_duration = '0:12'
      expect(video.duration).to eq 12
      video.natural_duration = '1:01'
      expect(video.duration).to eq 61
      video.natural_duration = '1:42'
      expect(video.duration).to eq 102
      video.natural_duration = '1:00:00'
      expect(video.duration).to eq 3600
    end
  end
end
