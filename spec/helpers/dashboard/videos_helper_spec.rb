require 'rails_helper'

RSpec.describe Dashboard::VideosHelper, type: :helper do
  before(:each) { @video = FactoryGirl.create(:video) }
  
  context 'video' do
    it { expect(video_path @video).to eq playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(video_url @video).to eq playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  context 'move_video' do
    it { expect(move_video_path @video).to eq move_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(move_video_url @video).to eq move_playlist_video_url(@video, playlist_id: @video.playlist) }
  end

  context 'edit_video' do
    it { expect(edit_video_path @video).to eq edit_playlist_video_path(@video, playlist_id: @video.playlist) }
    it { expect(edit_video_url @video).to eq edit_playlist_video_url(@video, playlist_id: @video.playlist) }
  end
end
