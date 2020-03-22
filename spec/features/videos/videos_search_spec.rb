require 'rails_helper'

RSpec.feature 'Videos search', type: :feature do
  describe 'searching by length' do
    before do
      @short = FactoryBot.create(:video, duration: 200, title: 'Short', youtube_id: '1')
      @medium = FactoryBot.create(:video, duration: 600, title: 'Medium', youtube_id: '2')
      @long = FactoryBot.create(:video, duration: 1200, title: 'Long', youtube_id: '3')
    end

    scenario 'can search for short length videos' do
      visit videos_path
      choose 'Cortos'
      click_button 'Aplicar filtros'
      expect(page).to have_link @short.title, href: video_path(@short)
      expect(page).not_to have_link @medium.title, href: video_path(@medium)
      expect(page).not_to have_link @long.title, href: video_path(@long)
    end

    scenario 'can search for medium length videos' do
      visit videos_path
      choose 'Medios'
      click_button 'Aplicar filtros'
      expect(page).not_to have_link @short.title, href: video_path(@short)
      expect(page).to have_link @medium.title, href: video_path(@medium)
      expect(page).not_to have_link @long.title, href: video_path(@long)
    end

    scenario 'can search for long length videos' do
      visit videos_path
      choose 'Largos'
      click_button 'Aplicar filtros'
      expect(page).not_to have_link @short.title, href: video_path(@short)
      expect(page).not_to have_link @medium.title, href: video_path(@medium)
      expect(page).to have_link @long.title, href: video_path(@long)
    end
  end

  describe 'searching by topic' do
    before do
      @topic1 = FactoryBot.create(:topic, title: 'First Topic')
      @topic2 = FactoryBot.create(:topic, title: 'Second Topic')
      @playlist1 = FactoryBot.create(:playlist, topic: @topic1)
      @playlist2 = FactoryBot.create(:playlist, topic: @topic2)
      @video1 = FactoryBot.create(:video, title: 'First', youtube_id: 'A', playlist: @playlist1)
      @video2 = FactoryBot.create(:video, title: 'Second', youtube_id: 'B', playlist: @playlist2)
    end

    scenario 'can search for videos in a topic' do
      visit videos_path

      check 'First Topic'
      click_button 'Aplicar filtros'
      expect(page).to have_link @video1.title, href: video_path(@video1)
      expect(page).not_to have_link @video2.title, href: video_path(@video2)
    end

    scenario 'can search for videos in multiple topics' do
      visit videos_path

      check 'First Topic'
      check 'Second Topic'
      click_button 'Aplicar filtros'
      expect(page).to have_link @video1.title, href: video_path(@video1)
      expect(page).to have_link @video2.title, href: video_path(@video2)
    end
  end

  private

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
