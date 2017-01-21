require 'rails_helper'

RSpec.describe Playlist, type: :model do

  it 'has a valid factory' do
    playlist = FactoryGirl.build(:playlist)
    expect(playlist).to be_valid
  end

  context 'validation' do
    it 'is not valid without title' do
      playlist = FactoryGirl.build(:playlist, title: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long title' do
      playlist = FactoryGirl.build(:playlist, title: 'A' * 101)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without description' do
      playlist = FactoryGirl.build(:playlist, description: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long description' do
      playlist = FactoryGirl.build(:playlist, description: 'A' * 5001)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without YouTube ID' do
      playlist = FactoryGirl.build(:playlist, youtube_id: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long YouTube ID' do
      playlist = FactoryGirl.build(:playlist, youtube_id: 'A' * 101)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without a card' do
      playlist = FactoryGirl.build(:playlist, card: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without a playlist photo' do
      playlist = FactoryGirl.build(:playlist, thumbnail: nil)
      expect(playlist).not_to be_valid
    end

    it 'is valid without a topic' do
      playlist = FactoryGirl.build(:playlist, topic: nil)
      expect(playlist).to be_valid
    end
  end

  context 'videos association' do
    it 'reports total length' do
      playlist = FactoryGirl.build(:playlist)
      video1 = FactoryGirl.create(:video, youtube_id: '12345', duration: 60, playlist: playlist)
      video2 = FactoryGirl.create(:video, youtube_id: '12346', duration: 90, playlist: playlist)
      expect(playlist.total_length).to eq 150
    end
  end

  context 'slug' do
    it 'generates a valid slug' do
      playlist = FactoryGirl.create(:playlist, title: 'Sample')
      expect(playlist.slug).to eq 'sample'
    end
  end
  
  context 'topic association' do
    it 'may belong to a topic' do
      playlist = FactoryGirl.create(:playlist)
      expect(playlist).to respond_to(:topic)
    end
  end

  context 'videos association' do
    it 'has many videos' do
      playlist = FactoryGirl.create(:playlist)
      expect(playlist).to respond_to(:videos)
    end
  end
end
