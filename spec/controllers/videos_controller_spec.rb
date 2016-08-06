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
      get :show, id: @video, playlist_id: @playlist
      expect(response).to be_success
    end

    it 'should render the show template' do
      get :show, id: @video, playlist_id: @playlist
      expect(page).to render_template :show
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

  context 'GET #new' do
    it 'should be success' do
      get :new
      expect(response).to be_success
    end

    it 'should render the new template' do
      get :new
      expect(response).to render_template :new
    end

    it 'should assign a new video' do
      get :new
      expect(assigns(:video)).to be
    end
  end

  context 'POST #create' do
    context 'when providing valid arguments' do
      before(:each) do
        @playlist = FactoryGirl.create(:playlist)
        @video = FactoryGirl.attributes_for(:video)
        @video["playlist_id"] = @playlist.id
      end

      it 'should update the database' do
        expect {
          post :create, video: @video
        }.to change { Video.count }.by 1
      end

      it 'should assign the saved video' do
        post :create, video: @video
        expect(assigns(:video).title).to eq @video[:title]
      end

      it 'should redirect' do
        post :create, video: @video
        expect(response).to have_http_status 302
      end
    end

    context 'when providing invalid arguments' do
      before(:each) do
        @video = FactoryGirl.attributes_for(:video, title: nil)
      end

      it 'should not update the database' do
        expect {
          post :create, video: @video
        }.to change { Video.count }.by 0
      end

      it 'should assign the half-saved video' do
        post :create, video: @video
        expect(assigns(:video)).to be
      end

      it 'should render the new template' do
        post :create, video: @video
        expect(response).to render_template :new
      end
    end
  end
end
