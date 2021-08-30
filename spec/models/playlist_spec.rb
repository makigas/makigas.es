# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it 'has a valid factory' do
    playlist = build(:playlist)
    expect(playlist).to be_valid
  end

  describe 'validation' do
    it 'is not valid without title' do
      playlist = build(:playlist, title: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long title' do
      playlist = build(:playlist, title: 'A' * 101)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without description' do
      playlist = build(:playlist, description: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long description' do
      playlist = build(:playlist, description: 'A' * 5001)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without YouTube ID' do
      playlist = build(:playlist, youtube_id: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid with a long YouTube ID' do
      playlist = build(:playlist, youtube_id: 'A' * 101)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without a card' do
      playlist = build(:playlist, card: nil)
      expect(playlist).not_to be_valid
    end

    it 'is not valid without a playlist photo' do
      playlist = build(:playlist, thumbnail: nil)
      expect(playlist).not_to be_valid
    end

    it 'is valid without a topic' do
      playlist = build(:playlist, topic: nil)
      expect(playlist).to be_valid
    end
  end

  describe 'videos association' do
    it 'reports total length' do
      playlist = build(:playlist)
      create(:video, youtube_id: '12345', duration: 60, playlist: playlist)
      create(:video, youtube_id: '12346', duration: 90, playlist: playlist)
      expect(playlist.total_length).to eq 150
    end

    it 'has many videos' do
      playlist = create(:playlist)
      expect(playlist).to respond_to(:videos)
    end
  end

  describe 'slug' do
    it 'generates a valid slug' do
      playlist = create(:playlist, title: 'Sample')
      expect(playlist.slug).to eq 'sample'
    end
  end

  describe 'topic association' do
    it 'may belong to a topic' do
      playlist = create(:playlist)
      expect(playlist).to respond_to(:topic)
    end
  end
end
