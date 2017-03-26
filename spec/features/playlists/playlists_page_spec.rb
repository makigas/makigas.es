require 'rails_helper'

RSpec.feature "Playlists page", type: :feature do
  before { @playlist = FactoryGirl.create(:playlist) }

  scenario 'displays information about playlists' do
    visit playlists_path

    expect(page).to have_link @playlist.title, href: playlist_path(@playlist)
    expect(page).to have_css "img[src*='#{@playlist.thumbnail.url(:default)}']"
  end

  feature 'number of videos' do
    scenario 'empty playlist' do
      visit playlists_path

      expect(page).to have_text '0 episodios'
    end

    scenario 'single video' do
      FactoryGirl.create(:video, playlist: @playlist)

      visit playlists_path

      expect(page).to have_text '1 episodio'
    end

    scenario 'many videos' do
      FactoryGirl.create(:video, playlist: @playlist, youtube_id: '1234')
      FactoryGirl.create(:video, playlist: @playlist, youtube_id: '1238')

      visit playlists_path

      expect(page).to have_text '2 episodios'
    end

    scenario 'scheduled videos are not counted' do
      FactoryGirl.create(:video, playlist: @playlist, youtube_id: '1234')
      FactoryGirl.create(:tomorrow_video, playlist: @playlist, youtube_id: '1238')

      visit playlists_path

      expect(page).to have_text '1 episodio'
    end
  end
end
