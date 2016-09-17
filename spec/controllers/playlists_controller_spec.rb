require 'rails_helper'

RSpec.describe PlaylistsController, type: :controller do
  context 'GET #index' do
    before(:each) do
      @playlists = FactoryGirl.create_list(:playlist, 3)
    end

    it 'should be success' do
      get :index
      expect(response).to be_success
    end

    it 'should render the index template' do
      get :index
      expect(response).to render_template :index
    end

    it 'should assign the list of playlists' do
      get :index
      expect(assigns(:playlists)).to match_array @playlists
    end
  end

  context 'GET #show' do
    before(:each) do
      # It would be a mess to create more than one video since I cannot
      # repeat the external ID for every video.
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist)
    end

    it 'should be success' do
      get :show, params: { id: @playlist }
      expect(response).to be_success
    end

    it 'should render the show template' do
      get :show, params: { id: @playlist }
      expect(response).to render_template :show
    end

    it 'should assign the given playlist' do
      get :show, params: { id: @playlist }
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

    it 'should assign an empty playlist' do
      get :new
      expect(assigns(:playlist).id).to eq nil
    end
  end

  context 'POST #create' do
    context 'when providing valid attributes' do
      it 'should save the playlist' do
        expect {
          post :create, params: { playlist: FactoryGirl.attributes_for(:playlist) }
        }.to change { Playlist.count }.by 1
      end

      it 'should assign the just saved playlist' do
        post :create, params: { playlist: FactoryGirl.attributes_for(:playlist) }
        expect(assigns(:playlist)).to be
      end

      it 'should redirect to the playlist' do
        post :create, params: { playlist: FactoryGirl.attributes_for(:playlist) }
        expect(response).to redirect_to playlist_path(assigns(:playlist))
      end
    end

    context 'when providing invalid attributes' do
      it 'should not save the playlist' do
        expect {
          post :create, params: { playlist: FactoryGirl.attributes_for(:playlist, title: nil) }
        }.to change { Playlist.count}.by 0
      end

      it 'should assign the playlist' do
        post :create, params: { playlist: FactoryGirl.attributes_for(:playlist, title: nil) }
        expect(assigns(:playlist)).to be
      end

      it 'should render the new template again' do
        post :create, params: { playlist: FactoryGirl.attributes_for(:playlist, title: nil) }
        expect(response).to render_template :new
      end
    end
  end

  context 'GET #edit' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end

    it 'should be success' do
      get :edit, params: { id: @playlist }
      expect(response).to be_success
    end

    it 'should use the edit layout' do
      get :edit, params: { id: @playlist }
      expect(response).to render_template :edit
    end

    it 'should assign the playlist' do
      get :edit, params: { id: @playlist }
      expect(assigns(:playlist)).to eq @playlist
    end
  end

  context 'PUT #update' do
    context 'when providing valid arguments' do
      before(:each) do
        @playlist = FactoryGirl.create(:playlist)
        @updated = FactoryGirl.attributes_for(:playlist, title: 'Updated')
      end

      it 'should update the data' do
        put :update, params: { id: @playlist, playlist: @updated }
        @playlist.reload
        expect(@playlist.title).to eq @updated[:title]
      end

      it 'should redirect to the playlist page' do
        put :update, params: { id: @playlist, playlist: @updated }
        expect(response).to redirect_to playlist_path(@playlist)
      end
    end

    context 'when providing invalid arguments' do
      before(:each) do
        @playlist = FactoryGirl.create(:playlist)
        @updated = FactoryGirl.attributes_for(:playlist, title: nil)
        @before = @playlist.title
      end

      it 'should not update the data' do
        put :update, params: { id: @playlist, playlist: @updated }
        @playlist.reload
        expect(@playlist.title).to eq @before
      end

      it 'should render the edit template' do
        put :update, params: { id: @playlist, playlist: @updated }
        expect(response).to render_template :edit
      end

      it 'should assign the model' do
        put :update, params: { id: @playlist, playlist: @updated }
        expect(assigns(:playlist)).to be
      end
    end
  end

  context 'DELETE #destroy' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end

    it 'should remove the item from the database' do
      expect {
        delete :destroy, params: { id: @playlist }
      }.to change { Playlist.count }.by -1
    end

    it 'should redirect to the playlists page' do
      delete :destroy, params: { id: @playlist }
      expect(response).to redirect_to playlists_path
    end
  end

  context 'GET #contents' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end

    it 'should not fail' do
      get :contents, params: { id: @playlist }
      expect(response).to be_success
    end

    it 'should assign the playlist' do
      get :contents, params: { id: @playlist }
      expect(assigns(:playlist)).to eq @playlist
    end
  end

  context 'PUT #sort' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video1 = FactoryGirl.create(:video, playlist: @playlist)
      @video2 = FactoryGirl.create(:video, playlist: @playlist, youtube_id: 'asdf')
    end

    it 'should move the video up when requested' do
      expect(@video2.position).to eq 2 # I don't trust this library.
      put :sort, params: { id: @playlist, video: @video2.id, operation: :up }
      @video2.reload
      expect(@video2.position).to eq 1
    end

    it 'should move the video down when requested' do
      expect(@video1.position).to eq 1 # I don't trust this library.
      put :sort, params: { id: @playlist, video: @video1.id, operation: :down }
      @video1.reload
      expect(@video1.position).to eq 2
    end

    it 'should redirect after operation' do
      put :sort, params: { id: @playlist, video: @video1.id, operation: :down }
      expect(response).to redirect_to contents_playlist_path(@playlist)
    end
  end
end
