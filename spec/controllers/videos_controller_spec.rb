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
          post :create, params: { video: @video }
        }.to change { Video.count }.by 1
      end

      it 'should assign the saved video' do
        post :create, params: { video: @video }
        expect(assigns(:video).title).to eq @video[:title]
      end

      it 'should redirect' do
        post :create, params: { video: @video }
        expect(response).to have_http_status 302
      end
    end

    context 'when providing invalid arguments' do
      before(:each) do
        @video = FactoryGirl.attributes_for(:video, title: nil)
      end

      it 'should not update the database' do
        expect {
          post :create, params: { video: @video }
        }.to change { Video.count }.by 0
      end

      it 'should assign the half-saved video' do
        post :create, params: { video: @video }
        expect(assigns(:video)).to be
      end

      it 'should render the new template' do
        post :create, params: { video: @video }
        expect(response).to render_template :new
      end
    end
  end

  context 'GET #edit' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end

    it 'should be success' do
      get :edit, params: { id: @video.id, playlist_id: @playlist.id }
      expect(response).to be_success
    end

    it 'should assign the video and the playlist' do
      get :edit, params: { id: @video.id, playlist_id: @playlist.id }
      expect(assigns(:video)).to eq @video
      expect(assigns(:playlist)).to eq @playlist
    end

    it 'should render the edit template' do
      get :edit, params: { id: @video.id, playlist_id: @playlist.id }
      expect(response).to render_template :edit
    end
  end

  context 'PUT #update' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, title: 'Foo', playlist: @playlist)
    end

    context 'when given correct arguments' do
      before(:each) do
        @updated = FactoryGirl.attributes_for(:video, title: 'Bar', playlist: @playlist)
      end

      it 'should update the item' do
        put :update, params: { id: @video, playlist_id: @playlist, video: @updated }
        video = Video.find(@video.id)
        expect(video.title).to eq 'Bar'
      end

      it 'should redirect to the video page' do
        put :update, params: { id: @video, playlist_id: @playlist, video: @updated }
        expect(response).to redirect_to playlist_video_path(@video, playlist_id: @playlist)
      end
    end

    context 'when given wrong arguments' do
      before(:each) do
        @updated = FactoryGirl.attributes_for(:video, title: nil, playlist: @playlist)
      end

      it 'should not update the item' do
        put :update, params: { id: @video, playlist_id: @playlist, video: @updated }
        @video.reload
        expect(@video.title).to eq 'Foo'
      end

      it 'should not redirect' do
        put :update, params: { id: @video, playlist_id: @playlist, video: @updated }
        expect(response.status).to eq 200
      end

      it 'should render the edit template again' do
        put :update, params: { id: @video, playlist_id: @playlist, video: @updated }
        expect(response).to render_template :edit
      end
    end
  end

  context 'DELETE #destroy' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end

    it 'should remove the item from the database' do
      expect {
        delete :destroy, params: { id: @video, playlist_id: @playlist }
      }.to change { Video.count }.by -1
    end

    it 'should redirect to the playlist page' do
      delete :destroy, params: { id: @video, playlist_id: @playlist }
      expect(response).to redirect_to playlist_path(@playlist)
    end
  end
end
