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
    
    it 'should list playlists title' do
      visit topics_path
      expect(page).to have_content @topic.title
    end
  end
end
