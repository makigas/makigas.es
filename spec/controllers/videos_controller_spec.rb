require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  context 'GET #show' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end
    
    it 'should be success' do
      get :show, id: @video, playlist_id: @playlist
      expect(response).to be_success
    end
    
    it 'should assign the video' do
      get :show, id: @video, playlist_id: @playlist
      expect(assigns(:video)).to eq @video
    end
    
    it 'should assign the playlist' do
      get :show, id: @video, playlist_id: @playlist
      expect(assigns(:playlist)).to eq @playlist
    end
  end
end
