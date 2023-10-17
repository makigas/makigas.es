# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                     :integer          not null, primary key
#  color                  :string
#  description            :string           not null
#  forum_url              :string
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parent_topic_id        :bigint
#
# Indexes
#
#  index_topics_on_parent_topic_id  (parent_topic_id)
#  index_topics_on_slug             (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Topic do
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

  describe 'parent topic' do
    let(:parent) { create(:topic, title: 'Parent topic') }

    it 'may belong to another topic' do
      topic = create(:topic, title: 'Child topic', parent_topic: parent)
      aggregate_failures do
        expect(topic.persisted?).to be true
        expect(topic.parent_topic).to eq parent
        expect(parent.child_topics).to contain_exactly(topic)
      end
    end
  end

  describe 'playlists association' do
    it 'has playlists' do
      topic = create(:topic)
      create(:playlist, topic:)
      expect(topic).to respond_to(:playlists)
    end

    it 'nullifies its playlists when removed' do
      topic = create(:topic)
      playlist = create(:playlist, topic:)
      topic.destroy
      playlist.reload
      expect(playlist.topic).to be_nil
    end
  end

  describe 'playlists_with_children association' do
    describe 'when there are no child playlists' do
      let(:playlist) { create(:playlist) }
      let(:topic) { create(:topic, playlists: [playlist]) }

      it 'returns the playlists in this topic' do
        expect(topic.playlists_with_children).to contain_exactly(playlist)
      end
    end

    describe 'when there are child playlists' do
      let(:child_playlist) { create(:playlist) }
      let(:child_topic) { create(:topic, playlists: [child_playlist]) }
      let(:playlist) { create(:playlist) }
      let(:topic) { create(:topic, playlists: [playlist], child_topics: [child_topic]) }

      it 'includes the children playlist too' do
        expect(topic.playlists_with_children).to contain_exactly(playlist, child_playlist)
      end
    end
  end

  describe '#content_updated_at' do
    let(:topic) { create(:topic) }
    let(:playlist) { create(:playlist, topic:) }

    describe 'when the topic is more recent than the playlist' do
      before do
        topic.update(updated_at: 2.days.ago)
        playlist.update(updated_at: 3.days.ago)
      end

      it 'matches the topic updated at' do
        expect(topic.content_updated_at).to eq(topic.updated_at)
      end
    end

    describe 'when the playlist is more recent than the topic' do
      before do
        topic.update(updated_at: 3.days.ago)
        playlist.update(updated_at: 2.days.ago)
      end

      it 'matches the playlist updated at' do
        expect(topic.content_updated_at.iso8601).to eq(playlist.updated_at.iso8601)
      end
    end
  end
end
