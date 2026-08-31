# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Redirections' do
  it 'redirects the XML feed for videos' do
    get '/videos/feed'
    expect(response).to redirect_to '/videos.atom'
  end

  it 'redirects the old topic page' do
    get '/topics/cooking'
    expect(response).to redirect_to '/explorar/tema/cooking'
  end

  it 'redirects the old topic feed URL' do
    get '/topics/cooking/feed'
    expect(response).to redirect_to '/explorar/tema/cooking'
  end

  it 'redirects the old /temas topic feed URL' do
    get '/temas/cooking/feed'
    expect(response).to redirect_to '/explorar/tema/cooking'
  end

  it 'redirects the old /temas topic page' do
    get '/temas/cooking'
    expect(response).to redirect_to '/explorar/tema/cooking'
  end

  it 'redirects the XML feed for playlist' do
    create(:playlist, slug: 'development')
    get '/series/development/feed'
    expect(response).to redirect_to '/series/development.atom'
  end

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
