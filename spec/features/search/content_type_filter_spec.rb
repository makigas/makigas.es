# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searching videos by content type' do
  before do
    Video.clear_index!
    Playlist.clear_index!
  end

  describe 'when unset' do
    let(:video) { create(:video) }
    let(:playlist) { video.playlist }

    before do
      video.save
      Search::Indexer.reindex!(async: false)

      visit search_path
      within('.Layout__sidebar') do
        click_on 'Todo'
      end
    end

    it 'returns videos' do
      within('main') do
        expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: playlist)
      end
    end

    it 'returns playlists' do
      within('main') do
        expect(page).to have_link playlist.title, href: playlist_path(playlist)
      end
    end
  end

  describe 'when filtering by lesson' do
    let(:video) { create(:video) }
    let(:playlist) { video.playlist }

    before do
      video.save
      Search::Indexer.reindex!(async: false)

      visit search_path
      within('.Layout__sidebar') do
        click_on 'Lecciones'
      end
    end

    it 'returns videos' do
      within('main') do
        expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: playlist)
      end
    end

    it 'does not return playlists' do
      within('main') do
        expect(page).to have_no_link href: playlist_path(playlist)
      end
    end
  end

  describe 'when filtering by course' do
    let(:video) { create(:video) }
    let(:playlist) { video.playlist }

    before do
      video.save
      Search::Indexer.reindex!(async: false)

      visit search_path
      within('.Layout__sidebar') do
        click_on 'Cursos'
      end
    end

    it 'returns videos' do
      within('main') do
        expect(page).to have_no_link href: playlist_video_path(video, playlist_id: playlist)
      end
    end

    it 'returns playlists' do
      within('main') do
        expect(page).to have_link playlist.title, href: playlist_path(playlist)
      end
    end
  end
end
