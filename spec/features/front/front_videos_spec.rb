# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos listed in front page', type: :feature do
  let!(:video) { create(:video) }

  it 'displays thumbnail' do
    visit root_path
    within '.recent-videos' do
      expect(page).to have_css "img[src='https://i1.ytimg.com/vi/#{video.youtube_id}/mqdefault.jpg']"
    end
  end

  it 'links to the video' do
    visit root_path
    within '.recent-videos' do
      expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: video.playlist)
    end
  end

  it "doesn't show videos hidden from front" do
    hidden = create(:video, title: 'Hidden', youtube_id: 'AABBCC', unfeatured: true)

    visit root_path

    aggregate_failures do
      within '.recent-videos' do
        expect(page).to have_link video.title
        expect(page).not_to have_link hidden.title
      end
    end
  end

  it "doesn't show videos not yet published" do
    scheduled = create(:tomorrow_video, youtube_id: 'TOMORROW', title: 'Scheduled one')
    published = create(:yesterday_video, youtube_id: 'YESTERDAY', title: 'This is published')

    visit root_path

    aggregate_failures do
      within '.recent-videos' do
        expect(page).to have_link published.title
        expect(page).not_to have_link scheduled.title
      end
    end
  end
end
