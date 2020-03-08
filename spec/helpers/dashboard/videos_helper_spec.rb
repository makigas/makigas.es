require 'rails_helper'

RSpec.describe Dashboard::VideosHelper, type: :helper do
  before { @video = FactoryBot.create(:video) }

  describe 'dashboard_video' do
    it { expect(dashboard_video_path(@video)).to eq dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(dashboard_video_url(@video)).to eq dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  describe 'move_dashboard_video' do
    it { expect(move_dashboard_video_path(@video)).to eq move_dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(move_dashboard_video_url(@video)).to eq move_dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  describe 'edit_dashboard_video' do
    it { expect(edit_dashboard_video_path(@video)).to eq edit_dashboard_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(edit_dashboard_video_url(@video)).to eq edit_dashboard_playlist_video_url(@video, playlist_id: @video.playlist) }
  end
end
