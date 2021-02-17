# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::VideosHelper, type: :helper do
  let(:video) { FactoryBot.create(:video) }

  describe 'dashboard_video' do
    it 'works for path' do
      path = dashboard_video_path(video)
      expect(path).to eq dashboard_playlist_video_path(video, playlist_id: video.playlist)
    end

    it 'works for URL' do
      url = dashboard_video_url(video)
      expect(url).to eq dashboard_playlist_video_url(video, playlist_id: video.playlist)
    end
  end

  describe 'move_dashboard_video' do
    it 'works for path' do
      path = move_dashboard_video_path(video)
      expect(path).to eq move_dashboard_playlist_video_path(video, playlist_id: video.playlist)
    end

    it 'works for URL' do
      url = move_dashboard_video_url(video)
      expect(url).to eq move_dashboard_playlist_video_url(video, playlist_id: video.playlist)
    end
  end

  describe 'edit_dashboard_video' do
    it 'works for path' do
      path = edit_dashboard_video_path(video)
      expect(path).to eq edit_dashboard_playlist_video_path(video, playlist_id: video.playlist)
    end

    it 'works for URL' do
      url = edit_dashboard_video_url(video)
      expect(url).to eq edit_dashboard_playlist_video_url(video, playlist_id: video.playlist)
    end
  end
end
