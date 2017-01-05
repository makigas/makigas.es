require 'rails_helper'

RSpec.feature "Playlists", type: :feature do
  context 'listing playlists' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end
    
    it 'should be success' do
      visit playlists_path
      expect(page).to have_http_status :success
    end
    
    it 'should list playlists title' do
      visit playlists_path
      expect(page).to have_content @playlist.title
    end
  end
  
  context 'showing playlist page' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist, duration: 83)
    end
    
    it 'should be success' do
      visit playlist_path @playlist
      expect(page).to have_http_status :success
    end
    
    it 'should list playlist title' do
      visit playlist_path @playlist
      expect(page).to have_content @playlist.title
    end
    
    it 'should list playlist description' do
      visit playlist_path @playlist
      expect(page).to have_content @playlist.description
    end
    
    it 'should list video title' do
      visit playlist_path @playlist
      expect(page).to have_content @video.title
    end
    
    it 'should list video description' do
      visit playlist_path @playlist
      expect(page).to have_content @video.description
    end
    
    it 'should display video length' do
      visit playlist_path @playlist
      expect(page).to have_content '1:23'
    end
  end
end
