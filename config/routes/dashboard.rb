# frozen_string_literal: true

constraints subdomain: 'dashboard' do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  namespace :dashboard, path: '' do
    root to: 'dashboard#index', as: ''
    resources :topics do
      get :order
      put :reorder
    end
    resources :videos, only: %i[index new create] do
      put :update_slug, path: 'modal/slug', on: :collection
    end
    resources :tips
    resources :playlists do
      get :videos, on: :member
      get :tags, on: :member
      put :retag, path: :tags, on: :member
      resources :videos, except: %i[index new create] do
        resources :links
        resource :transcription, only: %i[show create update destroy]
        resource :show_note, only: %i[show create update destroy]
        put :move, on: :member
      end
    end
    resources :users
    resources :tags
    resource :searches, only: %i[show]

    # Pending actions
    namespace :pending do
      resource :tags, only: %w[show update]
      resource :transcriptions, only: :show
      resource :show_notes, only: :show
    end
  end
end
