require 'rails_helper'

RSpec.feature "Playlist page", type: :feature do
  before { @playlist = FactoryBot.create(:playlist) }

  scenario 'displays playlist information' do
    visit playlist_path(@playlist)

    expect(page).to have_text @playlist.title
    expect(page).to have_text @playlist.description
    expect(page).to have_css "img[src*='#{@playlist.thumbnail.url(:small)}']"
  end

  scenario 'displays information about videos in this playlist' do
    @video = FactoryBot.create(:video, playlist: @playlist, duration: 133)

    visit playlist_path(@playlist)

    expect(page).to have_text video_title(@video)
    expect(page).to have_text @video.description
    expect(page).to have_text '2:13'
    expect(page).to have_css "a[href*='#{video_path(@video)}']"
  end

  scenario 'scheduled videos are not displayed' do
    @published = FactoryBot.create(:yesterday_video, playlist: @playlist, title: 'Yesterday', youtube_id: 'YESTERDAY')
    @scheduled = FactoryBot.create(:tomorrow_video, playlist: @playlist, title: 'Tomorrow', youtube_id: 'TOMORROW')

    visit playlist_path(@playlist)

    expect(page).to have_text video_title(@published)
    expect(page).to have_css "a[href*='#{video_path(@published)}']"
    expect(page).not_to have_text video_title(@scheduled)
    expect(page).not_to have_css "a[href*='#{video_path(@scheduled)}']"
  end

  private

  def video_title(video)
    "#{video.position}. #{video.title}"
  end

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
