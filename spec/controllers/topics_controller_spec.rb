require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  context 'GET #index' do
    before(:each) do
      @topics = FactoryGirl.create_list(:topic, 5)
    end

    it 'should be success' do
      get :index
      expect(response).to be_success
    end

    it 'should render the index layout' do
      get :index
      expect(response).to render_template :index
    end

    it 'should assign the list of topics' do
      get :index
      expect(assigns(:topics)).to match_array @topics
    end
  end

  context 'GET #new' do
    it 'should be success' do
      get :new
      expect(response).to be_success
    end

    it 'should render the new layout' do
      get :new
      expect(response).to render_template :new
    end

    it 'should assign a brand new topic' do
      get :new
      expect(assigns(:topic)).to be
      expect(assigns(:topic).persisted?).to eq false
    end
  end

  context 'POST #create' do
    context 'when providing valid arguments' do
      before(:each) do
        @topic = FactoryGirl.attributes_for(:topic)
      end

      it 'should save the item' do
        expect {
          post :create, params: { topic: @topic }
        }.to change { Topic.count }.by 1
      end

      it 'should assign the topic' do
        post :create, params: { topic: @topic }
        expect(assigns(:topic).id).to be
      end
      
      it 'should redirect to the topic path' do
        post :create, params: { topic: @topic }
        expect(response).to redirect_to topic_path(assigns(:topic))
      end
    end

    context 'when providing wrong arguments' do
      before(:each) do
        @topic = FactoryGirl.attributes_for(:topic, title: nil)
      end

      it 'should not save the item' do
        expect {
          post :create, params: { topic: @topic }
        }.not_to change { Topic.count }
      end

      it 'should have HTTP status 200' do
        post :create, params: { topic: @topic }
        expect(response.status).to eq 200
      end

      it 'should assign the topic' do
        post :create, params: { topic: @topic }
        expect(assigns(:topic)).to be
      end

      it 'should render the new template again' do
        post :create, params: { topic: @topic }
        expect(response).to render_template :new
      end
    end
  end

  context 'GET #edit' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
    end
    
    it 'should be success' do
      get :edit, params: { id: @topic }
      expect(response).to be_success
    end

    it 'should assign the topic' do
      get :edit, params: { id: @topic }
      expect(assigns(:topic)).to eq @topic
    end

    it 'should render the edit template' do
      get :edit, params: { id: @topic }
      expect(response).to render_template :edit
    end
  end

  context 'PUT #update' do
    before(:each) do
      @topic = FactoryGirl.create(:topic, title: 'Foo')
    end

    context 'when providing valid arguments' do
      before(:each) do
        @updated = FactoryGirl.attributes_for(:topic, title: 'Bar')
      end

      it 'should update the item' do
        put :update, params: { id: @topic, topic: @updated }
        @topic.reload
        expect(@topic.title).to eq 'Bar'
      end

      it 'should redirect to the topic' do
        put :update, params: { id: @topic, topic: @updated }
        expect(response).to redirect_to topic_path(@topic)
      end
    end
    
    context 'when not providing valid arguments' do
      before(:each) do
        @updated = FactoryGirl.attributes_for(:topic, title: nil)
      end

      it 'should not update the item' do
        put :update, params: { id: @topic, topic: @updated }
        @topic.reload
        expect(@topic.title).to eq 'Foo'
      end

      it 'should be success' do
        put :update, params: { id: @topic, topic: @updated }
        expect(response.status).to eq 200
      end

      it 'should render the edit template' do
        put :update, params: { id: @topic, topic: @updated }
        expect(response).to render_template :edit
      end
    end
  end

  context 'DELETE #destroy' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    end

    it 'should remove the topic' do
      expect {
        delete :destroy, params: { id: @topic }
      }.to change { Topic.count }.by -1
    end

    it 'should nullify the playlist topic' do
      delete :destroy, params: { id: @topic }
      @playlist.reload
      expect(@playlist.topic).to eq nil
    end

    it 'should redirect to the topics' do
      delete :destroy, params: { id: @topic }
      expect(response).to redirect_to topics_path
    end
  end

  context 'GET #insert' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist_on = FactoryGirl.create(:playlist, topic: @topic)
      @playlist_off = FactoryGirl.create(:playlist, topic: nil)
    end

    it 'should be success' do
      get :insert, params: { id: @topic }
      expect(response).to be_success
    end

    it 'should assign the topic' do
      get :insert, params: { id: @topic }
      expect(assigns(:topic)).to eq @topic
    end

    it 'should assign playlists not in a topic' do
      get :insert, params: { id: @topic }
      expect(assigns(:playlists)).to match_array [@playlist_off]
    end

    it 'should render the insert template' do
      get :insert, params: { id: @topic }
      expect(response).to render_template :insert
    end
  end

  context 'POST #do_insert' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist)
    end

    it 'should update the topic for the playlist' do
      post :do_insert, params: { id: @topic, playlist: @playlist.id }
      @playlist.reload
      expect(@playlist.topic).to eq @topic
    end

    it 'should redirect to the topic' do
      post :do_insert, params: { id: @topic, playlist: @playlist.id }
      expect(response).to redirect_to topic_path(@topic)
    end
  end

  context 'DELETE #release' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    end

    it 'should remove the playlist from the topic' do
      delete :release, params: { id: @topic, playlist: @playlist.id }
      @playlist.reload
      expect(@playlist.topic).to eq nil
    end

    it 'should redirect to the topic' do
      delete :release, params: { id: @topic, playlist: @playlist.id }
      expect(response).to redirect_to topic_path(@topic)
    end
  end
end
