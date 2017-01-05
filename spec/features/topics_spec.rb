require 'rails_helper'

RSpec.feature "Topics", type: :feature do
  context 'listing topics' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
    end

    it 'should be success' do
      visit topics_path
      expect(page).to have_http_status :success
    end
    
    it 'should list topics title' do
      visit topics_path
      expect(page).to have_content @topic.title
    end
  end

  context 'showing a particular topic' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    end

    it 'should be success' do
      visit topic_path(@topic)
      expect(page).to have_http_status :success
    end

    it 'should show topic title' do
      visit topic_path(@topic)
      expect(page).to have_content @topic.title
    end

    it 'should show playlists' do
      visit topic_path(@topic)
      expect(page).to have_content @playlist.title
    end
  end
end
