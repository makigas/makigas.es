# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Topic page', type: :feature do
  before { @topic = FactoryBot.create(:topic) }

  scenario 'shows information about a topic' do
    visit topic_path(@topic)
    expect(page).to have_text @topic.title
    expect(page).to have_text @topic.description
    expect(page).to have_css "img[src*='#{@topic.thumbnail.url(:small)}']"
  end

  scenario 'shows playlists in a topic' do
    @playlist = FactoryBot.create(:playlist, topic: @topic)

    visit topic_path(@topic)

    expect(page).to have_text @playlist.title
    expect(page).to have_css "img[src*='#{@playlist.thumbnail.url(:default)}']"
    expect(page).to have_css "a[href*='#{playlist_path(@playlist)}']"
  end

  context 'when the playlist is empty' do
    before do
      @playlist = FactoryBot.create(:playlist, topic: @topic)
    end

    scenario 'shows the playlist length' do
      visit topic_path(@topic)
      expect(page).to have_text '0 episodios'
    end
  end

  context 'when the playlist has a video' do
    before do
      @playlist = FactoryBot.create(:playlist, topic: @topic)
      FactoryBot.create(:video, playlist: @playlist)
    end

    it 'shows the playlist length' do
      visit topic_path(@topic)
      expect(page).to have_text '1 episodio'
    end
  end

  context 'when the playlist has multiple videos' do
    before do
      @playlist = FactoryBot.create(:playlist, topic: @topic)
      FactoryBot.create(:video, playlist: @playlist, youtube_id: '1234')
      FactoryBot.create(:video, playlist: @playlist, youtube_id: '1235')
    end

    scenario 'shows the playlist length' do
      visit topic_path(@topic)
      expect(page).to have_text '2 episodios'
    end
  end

  context 'when the playlist has scheduled videos' do
    before do
      @playlist = FactoryBot.create(:playlist, topic: @topic)
      FactoryBot.create(:video, playlist: @playlist, youtube_id: '1234')
      FactoryBot.create(:video, playlist: @playlist, youtube_id: '1235', published_at: 2.days.from_now)
    end

    scenario 'scheduled videos are not counted' do
      visit topic_path(@topic)
      expect(page).to have_text '1 episodio'
    end
  end
end
