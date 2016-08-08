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
    
    it 'should list playlists description' do
      visit topics_path
      expect(page).to have_content @topic.description
    end
  end

  context 'creating a topic' do
    it 'should be success' do
      visit new_topic_path
      expect(page).to have_http_status :success
    end

    it 'should be able to insert data' do
      visit topics_path
      click_link 'Nueva temática'
      fill_in 'Title', with: 'My sample topic'
      fill_in 'Description', with: 'This topic is an example to test the feature'
      attach_file 'Buscar', Rails.root + 'spec/fixtures/topic.jpg', visible: false
      click_button 'Guardar'
      expect(page).to have_content 'My sample topic'
    end

    it 'should detect invalid data' do
      visit new_topic_path
      fill_in 'Description', with: 'Look, no title!'
      click_button 'Guardar'
      expect(page).to have_content 'Hay errores que impiden guardar'
    end
  end
end
