# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mission Control Jobs' do
  around do |example|
    previous_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :solid_queue
    example.run
  ensure
    ActiveJob::Base.queue_adapter = previous_adapter
  end

  before { host! 'dashboard.lvh.me' }

  it 'redirects unauthenticated users to the dashboard sign-in page' do
    get '/jobs'

    expect(response).to redirect_to('/users/sign_in')
  end

  it 'is available to authenticated dashboard users' do
    sign_in create(:user), scope: :user

    get '/jobs'

    expect(response).to have_http_status(:ok)
  end

  it 'is not routed from the public subdomain' do
    host! 'www.lvh.me'

    get '/jobs'

    expect(response).to have_http_status(:not_found)
  end
end
