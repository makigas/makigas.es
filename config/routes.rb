# frozen_string_literal: true

Rails.application.routes.draw do
  # Application error routes
  get '/404', to: 'error#not_found', via: :all
  get '/422', to: 'error#unprocessable_entity', via: :all
  get '/500', to: 'error#internal_server_error', via: :all

  # Dashboard routes
  constraints subdomain: 'dashboard' do
    devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords' }
    namespace :dashboard, path: '' do
      root to: 'dashboard#index', as: ''
      resources :topics
      resources :videos, only: %i[index new create]
      resources :playlists do
        get :videos, on: :member
        resources :videos, except: %i[index new create] do
          resources :links
          resource :transcription, only: %i[show create update destroy]
          resource :show_note, only: %i[show create update destroy]
          put :move, on: :member
        end
      end
      resources :users
      resources :opinions
    end
  end

  # Main application routes
  root to: 'front#index'

  resources :topics, only: %i[index show] do
    get :feed, on: :member, format: :xml
  end

  resources :videos, only: :index do
    get :feed, on: :collection, format: :xml
  end

  resources :playlists, path: 'series', only: %i[index show] do
    get :feed, on: :member
    resources :videos, path: '/', only: :show
  end
  get :terms, to: 'pages#terms'
  get :privacy, to: 'pages#privacy'
  get :disclaimer, to: 'pages#disclaimer'
  get :cookies, to: 'pages#cookies'
  get :discord, to: 'pages#discord'

  get :dnt, path: 'about/dnt', to: 'pages#dnt'

  get '/v/:id', to: 'videos#find_by_id'

  # Legacy routes (redirect only).
  get '/videos/:topic/:playlist/episodio/:video' => redirect('/series/%{playlist}/%{video}')
  get '/videos/:topic/:playlist' => redirect('/series/%{playlist}')
  get '/videos/:playlist' => redirect('/series/%{playlist}')
end
