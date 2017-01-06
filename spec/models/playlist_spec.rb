require 'rails_helper'

RSpec.describe Playlist, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      playlist = FactoryGirl.build(:playlist)
      expect(playlist).to be_valid
    end

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
  end

  context 'slug' do
    it 'generates a valid slug' do
      playlist = FactoryGirl.create(:playlist, title: 'Sample')
      expect(playlist.slug).to eq 'sample'
    end
  end
end
