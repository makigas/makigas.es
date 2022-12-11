# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Video find by ID' do
  let(:playlist) { create(:playlist, title: 'Videos musicales') }
  let(:video) { create(:video, title: 'Open Door', playlist:, youtube_id: '6VBwEeUkFrQ') }

  describe 'when the correct video is found' do
    it 'redirects to the correct video page' do
      visit "/v/#{video.youtube_id}"
      expect(page).to have_current_path playlist_video_path(video, playlist_id: playlist)
    end
  end

  describe 'when an incorrect video is found' do
    it 'does not redirect to anywhere' do
      visit '/v/123456'
      expect(page).to have_http_status :not_found
    end
  end
end
