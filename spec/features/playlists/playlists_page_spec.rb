# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists page', type: :feature do
  let(:playlist) { create(:playlist) }

  it 'displays information about playlists' do
    create(:video, playlist:)

    visit playlists_path

    aggregate_failures do
      expect(page).to have_link playlist.title, href: playlist_path(playlist)
      expect(page).to have_css "img[src*='#{playlist.thumbnail.url(:small)}']"
    end
  end

  describe 'number of videos' do
    it 'empty playlist is not presented' do
      visit playlists_path

      expect(page).not_to have_text playlist.title
    end

    it 'single video' do
      create(:video, playlist:)

      visit playlists_path

      aggregate_failures do
        expect(page).to have_text playlist.title
        expect(page).to have_text '1 episodio'
      end
    end

    it 'many videos' do
      create(:video, playlist:, youtube_id: '1234')
      create(:video, playlist:, youtube_id: '1238')

      visit playlists_path

      aggregate_failures do
        expect(page).to have_text playlist.title
        expect(page).to have_text '2 episodios'
      end
    end

    it 'scheduled videos are not counted' do
      create(:video, playlist:, youtube_id: '1234')
      create(:tomorrow_video, playlist:, youtube_id: '1238')

      visit playlists_path

      aggregate_failures do
        expect(page).to have_text playlist.title
        expect(page).to have_text '1 episodio'
      end
    end
  end
end
