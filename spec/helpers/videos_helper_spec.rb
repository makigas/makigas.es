# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosHelper do
  it 'gets video path' do
    video = create(:video)
    expect(video_path(video)).to eq playlist_video_path(video, playlist_id: video.playlist)
  end

  it 'gets video URL' do
    video = create(:video)
    expect(video_url(video)).to eq playlist_video_url(video, playlist_id: video.playlist)
  end
end
