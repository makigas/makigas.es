require 'rails_helper'

RSpec.describe Dashboard::VideosHelper, type: :helper do
  before(:each) { @video = FactoryBot.create(:video) }

  context 'dashboard_video' do
    it { expect(dashboard_video_path @video).to eq dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(dashboard_video_url @video).to eq dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  context 'move_dashboard_video' do
    it { expect(move_dashboard_video_path @video).to eq move_dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(move_dashboard_video_url @video).to eq move_dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  context 'edit_dashboard_video' do
    it { expect(edit_dashboard_video_path @video).to eq edit_dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(edit_dashboard_video_url @video).to eq edit_dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end
end
