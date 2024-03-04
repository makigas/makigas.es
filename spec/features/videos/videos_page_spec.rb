# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topics page' do
  it 'still loads without videos' do
    visit videos_path
    expect(page.status_code).to be 200
  end

  it 'displays information about videos' do
    video = create(:video, duration: 133)

    visit videos_path
    aggregate_failures do
      expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: video.playlist)
      expect(page).to have_text video.description
      expect(page).to have_text 'Duración: 2:13'
      expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
    end
  end

  it 'displays topic if the playlist has one' do
    topic = create(:topic)
    playlist = create(:playlist, topic:)
    create(:video, playlist:)

    visit videos_path
    expect(page).to have_link topic.title, href: topic_path(topic)
  end

  it 'scheduled videos are not displayed' do
    published = create(:yesterday_video, youtube_id: 'PUBLISHED', title: 'Published')
    scheduled = create(:tomorrow_video, youtube_id: 'TOMORROW', title: 'Scheduled')

    visit videos_path
    aggregate_failures do
      expect(page).to have_text published.title
      expect(page).to have_no_text scheduled.title
    end
  end
end
