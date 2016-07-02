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
end
