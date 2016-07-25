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
      get :show, id: @playlist
      expect(response).to be_success
    end

    it 'should render the show template' do
      get :show, id: @playlist
      expect(response).to render_template :show
    end

    it 'should assign the given playlist' do
      get :show, id: @playlist
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
          post :create, playlist: FactoryGirl.attributes_for(:playlist)
        }.to change { Playlist.count }.by 1
      end

      it 'should assign the just saved playlist' do
        post :create, playlist: FactoryGirl.attributes_for(:playlist)
        expect(assigns(:playlist)).to be
      end

      it 'should redirect to the playlist' do
        post :create, playlist: FactoryGirl.attributes_for(:playlist)
        expect(response).to redirect_to playlist_path(assigns(:playlist))
      end
    end

    context 'when providing invalid attributes' do
      it 'should not save the playlist' do
        expect {
          post :create, playlist: FactoryGirl.attributes_for(:playlist, title: nil)
        }.to change { Playlist.count}.by 0
      end

      it 'should assign the playlist' do
        post :create, playlist: FactoryGirl.attributes_for(:playlist, title: nil)
        expect(assigns(:playlist)).to be
      end

      it 'should render the new template again' do
        post :create, playlist: FactoryGirl.attributes_for(:playlist, title: nil)
        expect(response).to render_template :new
      end
    end
  end
end
