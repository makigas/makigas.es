# == Schema Information
#
# Table name: topics
#
#  id                     :integer          not null, primary key
#  title                  :string           not null
#  description            :string           not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  color                  :string
#
# Indexes
#
#  index_topics_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Topic, type: :model do

  it 'has a valid factory' do
    topic = FactoryGirl.build(:topic)
    expect(topic).to be_valid
  end

  context 'model' do
    it 'is not valid without a title' do
      topic = FactoryGirl.build(:topic, title: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid with a title longer than 50 characters' do
      topic = FactoryGirl.build(:topic, title: 'A' * 51)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a description' do
      topic = FactoryGirl.build(:topic, description: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a description longer than 250 characters' do
      topic = FactoryGirl.build(:topic, description: 'A' * 251)
      expect(topic).not_to be_valid
    end

    it 'is not valid without a thumbnail' do
      topic = FactoryGirl.build(:topic, thumbnail: nil)
      expect(topic).not_to be_valid
    end

    it 'is not valid without color' do
      topic = FactoryGirl.build(:topic, color: nil)
      expect(topic).not_to be_valid
    end
  end

  context 'slug' do
    it 'generates a slug' do
      topic = FactoryGirl.create(:topic, title: 'My topic')
      expect(topic.slug).to eq 'my-topic'
    end
  end

  context 'playlists association' do
    it 'should have playlists' do
      topic = FactoryGirl.create(:topic)
      playlist = FactoryGirl.create(:playlist, topic: topic)
      expect(topic).to respond_to(:playlists)
    end

    it 'should nullify its playlists when removed' do
      topic = FactoryGirl.create(:topic)
      playlist = FactoryGirl.create(:playlist, topic: topic)
      topic.destroy
      playlist.reload
      expect(playlist.topic).to eq nil
    end
  end
end
