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
end
