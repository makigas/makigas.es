require 'rails_helper'

RSpec.feature "Videos", type: :feature do
  describe 'listing all the videos' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @videos = ['1234', '1235', '1236'].
        map { |i| FactoryGirl.create(:video, title: "Video #{i}",
                                     playlist: @playlist, youtube_id: i) }
    end

    it 'should be success' do
      visit videos_path
      expect(page).to have_http_status :success
    end

    it 'should display the titles of the videos' do
      visit videos_path
      expect(page).to have_content @videos[0].title
      expect(page).to have_content @videos[1].title
      expect(page).to have_content @videos[2].title
    end

    it 'should render a link to the playlist' do
      visit videos_path
      expect(page).to have_link(@playlist.title, href: playlist_path(@playlist))
    end
  end
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
