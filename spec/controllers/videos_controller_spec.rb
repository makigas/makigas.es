require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  context 'GET #index' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @videos = ['1234', '1235', '1236'].
        map { |i| FactoryGirl.create(:video, playlist: @playlist, youtube_id: i) }
    end

    it 'should be success' do
      get :index
      expect(response).to be_success
    end

    it 'should assign the videos' do
      get :index
      expect(assigns(:videos)).to match_array @videos
    end

    it 'should render the index template' do
      get :index
      expect(page).to render_template :index
    end

  end

  context 'GET #show' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end
    
    it 'should be success' do
      get :show, params: { id: @video, playlist_id: @playlist }
      expect(response).to be_success
    end

    it 'should render the show template' do
      get :show, params: { id: @video, playlist_id: @playlist }
      expect(page).to render_template :show
    end
    
    it 'should assign the video' do
      get :show, params: { id: @video, playlist_id: @playlist }
      expect(assigns(:video)).to eq @video
    end
    
    it 'should assign the playlist' do
      get :show, params: { id: @video, playlist_id: @playlist }
      expect(assigns(:playlist)).to eq @playlist
    end
  end
end
