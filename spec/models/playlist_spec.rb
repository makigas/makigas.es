# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                     :integer          not null, primary key
#  card_content_type      :string
#  card_file_name         :string
#  card_file_size         :bigint
#  card_updated_at        :datetime
#  description            :text             not null
#  forum_url              :string
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  topic_id               :integer
#  youtube_id             :string           not null
#
# Indexes
#
#  index_playlists_on_slug      (slug) UNIQUE
#  index_playlists_on_topic_id  (topic_id)
#
require 'rails_helper'

RSpec.describe Playlist do
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
      create(:video, youtube_id: '12345', duration: 60, playlist:)
      create(:video, youtube_id: '12346', duration: 90, playlist:)
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

  describe '#with_public_videos' do
    describe 'when the playlist has public videos' do
      it 'gets included' do
        playlist = create(:playlist)
        create(:video, playlist:, published_at: 2.days.ago)
        expect(described_class.with_public_videos).to include(playlist)
      end
    end

    describe 'when the playlist has no public videos' do
      it 'will not be included' do
        playlist = create(:playlist)
        create(:video, playlist:, published_at: 2.days.after)
        expect(described_class.with_public_videos).not_to include(playlist)
      end
    end

    describe 'when the playlist has public and not public videos' do
      it 'gets included what can be included' do
        playlist = create(:playlist)
        create(:video, playlist:, published_at: 2.days.after)
        create(:video, playlist:, published_at: 2.days.ago)
        expect(described_class.with_public_videos).to include(playlist)
      end
    end
  end

  describe '#content_updated_at' do
    let(:playlist) { create(:playlist) }
    let(:video) { create(:video, playlist:) }

    describe 'when the playlist is more recent than the content' do
      before do
        playlist.update(updated_at: 2.days.ago)
        video.update(updated_at: 3.days.ago)
      end

      it 'matches the playlist updated at' do
        expect(playlist.content_updated_at).to eq(playlist.updated_at)
      end
    end

    describe 'when the content is more recent than the playlist' do
      before do
        playlist.update(updated_at: 3.days.ago)
        video.update(updated_at: 2.days.ago)
      end

      it 'matches the content updated at' do
        expect(playlist.content_updated_at.iso8601).to eq(video.updated_at.iso8601)
      end
    end
  end
end
