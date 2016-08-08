require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'model' do
    it 'has a valid factory' do
      topic = FactoryGirl.build(:topic)
      expect(topic).to be_valid
    end

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

    it 'is not valid without a photo' do
      topic = FactoryGirl.build(:topic, photo: nil)
      expect(topic).not_to be_valid
    end
  end

  describe 'slug' do
    it 'generates a slug' do
      topic = FactoryGirl.create(:topic, title: 'My topic')
      expect(topic.slug).to eq 'my-topic'
    end
  end
end
