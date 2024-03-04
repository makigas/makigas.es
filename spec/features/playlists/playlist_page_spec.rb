# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlist page' do
  let(:video) { create(:video, duration: 133) }
  let(:published) { create(:yesterday_video, title: 'Yesterday', youtube_id: 'YESTERDAY') }
  let(:scheduled) { create(:tomorrow_video, title: 'Tomorrow', youtube_id: 'TOMORROW') }
  let(:playlist) { create(:playlist, videos: [video, published, scheduled]) }

  it 'displays playlist information' do
    visit playlist_path(playlist)

    aggregate_failures do
      expect(page).to have_text playlist.title
      expect(page).to have_text playlist.description
      expect(page).to have_css "img[src*='#{playlist.thumbnail.url(:small)}']"
    end
  end

  it 'displays information about videos in this playlist' do
    visit playlist_path(playlist)

    aggregate_failures do
      expect(page).to have_text video_title(video)
      expect(page).to have_text video.description
      expect(page).to have_text '2:13'
      expect(page).to have_css "a[href*='#{video_path(video)}']"
    end
  end

  it 'scheduled videos are not displayed' do
    visit playlist_path(playlist)

    aggregate_failures do
      expect(page).to have_text video_title(published)
      expect(page).to have_css "a[href*='#{video_path(published)}']"
      expect(page).to have_no_text video_title(scheduled)
      expect(page).to have_no_css "a[href*='#{video_path(scheduled)}']"
    end
  end

  private

  def video_title(video)
    "#{video.position} #{video.title}"
  end

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
