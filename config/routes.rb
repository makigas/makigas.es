Rails.application.routes.draw do
  devise_for :users
  root to: 'front#index'

  # These routes should be limited to authorized users.
  resources :playlists, path: 'series', only: [:new, :create, :edit, :update, :destroy] do
    member do
      get :contents # Lets the authorized user to organize the playlist contents
      put :sort # Saves the changes made in :contents
    end
    resources :videos, path: '/', only: [:edit, :update, :destroy]
  end
  resources :videos, only: [:new, :create]
  resources :topics, only: [:new, :create, :edit, :update, :destroy] do
    member do
      get :insert, to: 'topics#insert'
      post :insert, to: 'topics#do_insert'
      delete :release, to: 'topics#release'
    end
  end
  
  # These are the public routes for my application.
  get :videos, to: 'videos#index'
  resources :playlists, path: 'series', only: [:index, :show] do
    resources :videos, path: '/', only: [:show]
  end
  resources :topics, only: [:index, :show]
end
