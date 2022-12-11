# frozen_string_literal: true

Rails.application.routes.draw do
  # Application error routes
  get '/404', to: 'error#not_found', via: :all
  get '/422', to: 'error#unprocessable_entity', via: :all
  get '/500', to: 'error#internal_server_error', via: :all

  # Dashboard routes
  constraints subdomain: 'dashboard' do
    devise_for :users, controllers: { sessions: 'users/sessions' }
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

      # Pending actions
      namespace :pending do
        resource :tags, only: %w[show update]
        resource :transcriptions, only: :show
        resource :show_notes, only: :show
      end
    end
  end

  # Main application routes
  root to: 'front#index'

  # Early access.
  get '/early' => redirect('http://early.makigas.es', status: 302)
  get '/early/videos', to: 'videos#early', format: :json

  # Legacy RSS feeds, must come first or there will be conflicts.
  get '/videos/feed' => redirect('/videos.atom')
  get '/temas/:topic/feed' => redirect('/temas/%{topic}.atom')
  get '/series/:playlist/feed' => redirect('/series/%{playlist}.atom')

  resources :topics, path: 'temas', only: %i[index show] do
    get :feed, on: :member, format: :xml
  end

  resources :videos, only: :index

  resources :playlists, path: 'series', only: %i[index show] do
    resources :videos, path: '/', only: :show
  end
  get :terms, path: 'terminos', to: 'pages#terms'
  get :privacy, path: 'privacidad', to: 'pages#privacy'
  get :disclaimer, path: 'responsabilidades', to: 'pages#disclaimer'
  get :cookies, to: 'pages#cookies'
  get :discord, to: 'pages#discord'

  get :dnt, to: 'pages#dnt'

  get '/v/:id', to: 'videos#find_by_id'

  # Legacy routes (redirect only).
  get '/videos/:topic/:playlist/episodio/:video' => redirect('/series/%{playlist}/%{video}')
  get '/videos/:topic/:playlist' => redirect('/series/%{playlist}')
  get '/videos/:playlist' => redirect('/series/%{playlist}')

  # Legacy routes for the old topic explorer
  get '/topics/:topic' => redirect('/temas/%{topic}')
  get '/topics/:topic/feed' => redirect('/temas/%{topic}.atom')
  get '/topics' => redirect('/temas')

  # Legacy routes for the text pages.
  get '/terms' => redirect('/terminos')
  get '/privacy' => redirect('/privacidad')
  get '/disclaimer' => redirect('/responsabilidades')
  get '/about/dnt' => redirect('/dnt')

  if Rails.env.development?
    mount Lookbook::Engine, at: '/lookbook'
    match('/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post])
  end
end
