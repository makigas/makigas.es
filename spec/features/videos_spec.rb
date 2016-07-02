require 'rails_helper'

RSpec.feature "Videos", type: :feature do
  describe 'showing the video page' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end
    
    it 'should be success' do
      visit playlist_video_path id: @video, playlist_id: @playlist
      expect(page).to have_http_status :success
    end
    
    it 'should render the video title' do
      visit playlist_video_path id: @video, playlist_id: @playlist
      expect(page).to have_content @video.title
    end
    
    it 'should render the video description' do
      visit playlist_video_path id: @video, playlist_id: @playlist
      expect(page).to have_content @video.description
    end
    
    it 'should render the playlist the video is in' do
      visit playlist_video_path id: @video, playlist_id: @playlist
      expect(page).to have_content @playlist.title
    end
    
    it 'should render the video' do
      visit playlist_video_path id: @video, playlist_id: @playlist
      expect(page).to have_css 'iframe'
    end
  end
end
