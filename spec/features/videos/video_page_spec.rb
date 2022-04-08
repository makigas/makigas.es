# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Video page', type: :feature do
  let(:video) { create(:video, duration: 133) }

  it 'there is information about the video' do
    visit_video video

    aggregate_failures do
      expect(page).to have_text video.title
      expect(page).to have_content video.description
      expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
    end
  end

  it 'there is a player embedded in' do
    visit_video video

    expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{video.youtube_id}']"
  end

  describe 'when the video has show notes' do
    let(:topic) { create(:topic) }
    let(:playlist) { create(:playlist, topic: topic) }
    let(:show_note) { build(:show_note, documentable: nil) }
    let(:video) { create(:video, playlist: playlist, show_note: show_note) }

    it 'presents the show notes' do
      visit_video video

      within("//div[@class='videoinfo__shownotes']") do
        expect(page).to have_content show_note.content
      end
    end
  end
end

private

def visit_video(video)
  visit playlist_video_path(video, playlist_id: video.playlist)
end
