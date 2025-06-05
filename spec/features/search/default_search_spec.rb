# frozen_string_literal: true

require 'rails_helper'
require 'byebug'

RSpec.describe 'Default search' do
  before do
    Video.clear_index!
    Playlist.clear_index!
  end

  it 'renders information about videos' do
    video = create(:video)
    Search::Indexer.reindex!(async: false)

    visit search_path
    aggregate_failures do
      within('main') do
        expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: video.playlist)
        expect(page).to have_link video.description, href: playlist_video_path(video, playlist_id: video.playlist)
        expect(page).to have_link 'Lección', href: playlist_video_path(video, playlist_id: video.playlist)
      end
    end
  end

  it 'does not render information about videos that are scheduled' do
    video = create(:tomorrow_video)
    Search::Indexer.reindex!(async: false)

    visit search_path
    aggregate_failures do
      within('main') do
        expect(page).to have_no_link video.title, href: playlist_video_path(video, playlist_id: video.playlist)
      end
    end
  end

  it 'renders information about playlists' do
    video = create(:video) # this video is linked to a playlist
    Search::Indexer.reindex!(async: false)

    visit search_path
    aggregate_failures do
      within('main') do
        expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
        expect(page).to have_link video.playlist.description, href: playlist_path(video.playlist)
        expect(page).to have_link 'Curso', href: playlist_path(video.playlist)
      end
    end
  end

  it 'does not render information about playlists without public videos' do
    video = create(:tomorrow_video)

    visit search_path
    aggregate_failures do
      within('main') do
        expect(page).to have_no_link video.playlist.title, href: playlist_path(video.playlist)
      end
    end
  end

  it 'does not render information about playlists with no videos' do
    playlist = create(:playlist)
    Search::Indexer.reindex!(async: false)

    visit search_path
    aggregate_failures do
      within('main') do
        expect(page).to have_no_link playlist.title, href: playlist_path(playlist)
      end
    end
  end
end
