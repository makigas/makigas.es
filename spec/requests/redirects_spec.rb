# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Redirections', type: :request do
  it 'redirects privacy to the new location' do
    get '/privacy'
    expect(response).to redirect_to '/privacidad'
  end

  it 'redirects terms to the new location' do
    get '/terms'
    expect(response).to redirect_to '/terminos'
  end

  it 'redirects disclaimers to the new location' do
    get '/disclaimer'
    expect(response).to redirect_to '/responsabilidades'
  end

  it 'redirects DNT to the new location' do
    get '/about/dnt'
    expect(response).to redirect_to '/dnt'
  end
end
