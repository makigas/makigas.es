# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topic page', type: :feature do
  let(:topic) { create(:topic) }

  it 'shows information about a topic' do
    visit topic_path(topic)
    expect(page).to have_text topic.title
  end

  it 'shows playlists in a topic' do
    playlist = create(:playlist, topic: topic)

    visit topic_path(topic)

    aggregate_failures do
      expect(page).to have_text playlist.title
      expect(page).to have_css "img[src*='#{playlist.thumbnail.url(:small)}']"
      expect(page).to have_css "a[href*='#{playlist_path(playlist)}']"
    end
  end

  context 'when the playlist is empty' do
    let(:playlist) { create(:playlist, videos: []) }
    let(:topic) { create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '0 episodios'
    end
  end

  context 'when the playlist has a video' do
    let(:video) { create(:video) }
    let(:playlist) { create(:playlist, videos: [video]) }
    let(:topic) { create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '1 episodio'
    end
  end

  context 'when the playlist has multiple videos' do
    let(:first) { create(:video, youtube_id: '1234') }
    let(:second) { create(:video, youtube_id: '1235') }
    let(:playlist) { create(:playlist, videos: [first, second]) }
    let(:topic) { create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '2 episodios'
    end
  end

  context 'when the playlist has scheduled videos' do
    let(:first) { create(:video, youtube_id: '1234') }
    let(:second) { create(:video, youtube_id: '1235', published_at: 2.days.from_now) }
    let(:playlist) { create(:playlist, videos: [first, second]) }
    let(:topic) { create(:topic, playlists: [playlist]) }

    it 'scheduled videos are not counted' do
      visit topic_path(topic)
      expect(page).to have_text '1 episodio'
    end
  end
end
