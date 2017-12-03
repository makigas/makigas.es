require 'rails_helper'

RSpec.describe VideosHelper, type: :helper do
  it 'should get video path' do
    video = FactoryBot.create(:video)
    expect(video_path(video)).to eq playlist_video_path(video, playlist_id: video.playlist)
  end

  it 'should get video URL' do
    video = FactoryBot.create(:video)
    expect(video_url(video)).to eq playlist_video_url(video, playlist_id: video.playlist)
  end
end
