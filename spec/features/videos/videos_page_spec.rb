# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Topics page', type: :feature do
  scenario 'still loads without videos' do
    visit videos_path
    expect(page.status_code).to be 200
  end

  scenario 'displays information about videos' do
    video = FactoryBot.create(:video, duration: 133)

    visit videos_path
    expect(page).to have_link video.title, href: playlist_video_path(video, playlist_id: video.playlist)
    expect(page).to have_text video.description
    expect(page).to have_text 'Duración: 2:13'
    expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
  end

  scenario 'displays topic if the playlist has one' do
    topic = FactoryBot.create(:topic)
    playlist = FactoryBot.create(:playlist, topic: topic)
    FactoryBot.create(:video, playlist: playlist)

    visit videos_path
    expect(page).to have_link topic.title, href: topic_path(topic)
  end

  scenario 'scheduled videos are not displayed' do
    published = FactoryBot.create(:yesterday_video, youtube_id: 'PUBLISHED', title: 'Published')
    scheduled = FactoryBot.create(:tomorrow_video, youtube_id: 'TOMORROW', title: 'Scheduled')

    visit videos_path
    expect(page).to have_text published.title
    expect(page).not_to have_text scheduled.title
  end
end
