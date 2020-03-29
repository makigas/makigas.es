# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos search', type: :feature do
  describe 'searching by length' do
    let!(:short) { FactoryBot.create(:video, duration: 200, title: 'Short', youtube_id: '1') }
    let!(:medium) { FactoryBot.create(:video, duration: 600, title: 'Medium', youtube_id: '2') }
    let!(:long) { FactoryBot.create(:video, duration: 1200, title: 'Long', youtube_id: '3') }

    it 'can search for short length videos' do
      visit videos_path
      choose 'Cortos'
      click_button 'Aplicar filtros'
      expect(page).to have_link short.title, href: video_path(short)
      expect(page).not_to have_link medium.title, href: video_path(medium)
      expect(page).not_to have_link long.title, href: video_path(long)
    end

    it 'can search for medium length videos' do
      visit videos_path
      choose 'Medios'
      click_button 'Aplicar filtros'
      expect(page).not_to have_link short.title, href: video_path(short)
      expect(page).to have_link medium.title, href: video_path(medium)
      expect(page).not_to have_link long.title, href: video_path(long)
    end

    it 'can search for long length videos' do
      visit videos_path
      choose 'Largos'
      click_button 'Aplicar filtros'
      expect(page).not_to have_link short.title, href: video_path(short)
      expect(page).not_to have_link medium.title, href: video_path(medium)
      expect(page).to have_link long.title, href: video_path(long)
    end
  end

  describe 'searching by topic' do
    let(:topic1) { FactoryBot.create(:topic, title: 'First Topic') }
    let(:topic2) { FactoryBot.create(:topic, title: 'Second Topic') }
    let(:playlist1) { FactoryBot.create(:playlist, topic: topic1) }
    let(:playlist2) { FactoryBot.create(:playlist, topic: topic2) }
    let!(:video1) { FactoryBot.create(:video, title: 'First', youtube_id: 'A', playlist: playlist1) }
    let!(:video2) { FactoryBot.create(:video, title: 'Second', youtube_id: 'B', playlist: playlist2) }

    it 'can search for videos in a topic' do
      visit videos_path

      check 'First Topic'
      click_button 'Aplicar filtros'
      expect(page).to have_link video1.title, href: video_path(video1)
      expect(page).not_to have_link video2.title, href: video_path(video2)
    end

    it 'can search for videos in multiple topics' do
      visit videos_path

      check 'First Topic'
      check 'Second Topic'
      click_button 'Aplicar filtros'
      expect(page).to have_link video1.title, href: video_path(video1)
      expect(page).to have_link video2.title, href: video_path(video2)
    end
  end

  private

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
