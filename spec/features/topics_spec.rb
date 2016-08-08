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

  context 'adding a topic to a playlist' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist_on = FactoryGirl.create(:playlist, topic: @topic)
      @playlist_off = FactoryGirl.create(:playlist, topic: nil)
    end

    it 'should have a valid view' do
      visit insert_topic_path(@topic)
      expect(page).to have_http_status :success
    end

    it 'should have a valid workflow' do
      visit topic_path(@topic)
      click_link 'Agregar listas'
      select @playlist_off.title, from: 'Playlist'
      click_button 'Insertar'
      expect(page).to have_content @topic.title
      expect(page).to have_content @playlist_off.title
    end

    it 'should not suggest playlists already in a playlist' do
      visit insert_topic_path(@topic)
      expect(page).to have_select 'Playlist', options: [@playlist_off.title]
    end
  end

  context 'removing a playlist from a topic' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    end

    it 'should have a valid workflow' do
      visit topic_path(@topic)
      click_button 'Eliminar lista'
      expect(page).to have_content @topic.title
      expect(page).not_to have_content @playlist.title
    end
  end
end
