# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Video page' do
  let(:video) { create(:video, duration: 133) }

  it 'there is information about the video' do
    visit_video video

    aggregate_failures do
      expect(page).to have_text video.title
      expect(page).to have_text video.description
      expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
    end
  end

  it 'there is a player embedded in' do
    visit_video video

    expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{video.youtube_id}']"
  end

  describe 'when the video is not published' do
    before do
      video.update(published_at: 2.days.from_now)
    end

    it 'is not visible' do
      visit_video video

      aggregate_failures do
        expect(page).to have_http_status :not_found
        expect(page).to have_no_text video.title
      end
    end
  end
end

def visit_video(video)
  visit playlist_video_path(video, playlist_id: video.playlist)
end
