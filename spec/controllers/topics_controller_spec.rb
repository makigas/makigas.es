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
end
