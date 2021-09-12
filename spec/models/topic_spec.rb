# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, type: :model do
  it 'has a valid factory' do
    topic = build(:topic)
    expect(topic).to be_valid
  end

  describe 'model' do
    it 'is not valid without a title' do
      topic = build(:topic, title: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid with a title longer than 50 characters' do
      topic = build(:topic, title: 'A' * 51)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a description' do
      topic = build(:topic, description: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a description longer than 250 characters' do
      topic = build(:topic, description: 'A' * 251)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a thumbnail' do
      topic = build(:topic, thumbnail: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid without color' do
      topic = build(:topic, color: nil)
      expect(topic).not_to be_valid
    end
  end

  describe 'slug' do
    it 'generates a slug' do
      topic = create(:topic, title: 'My topic')
      expect(topic.slug).to eq 'my-topic'
    end
  end

  describe 'playlists association' do
    it 'has playlists' do
      topic = create(:topic)
      create(:playlist, topic: topic)
      expect(topic).to respond_to(:playlists)
    end

    it 'nullifies its playlists when removed' do
      topic = create(:topic)
      playlist = create(:playlist, topic: topic)
      topic.destroy
      playlist.reload
      expect(playlist.topic).to eq nil
    end
  end
end
