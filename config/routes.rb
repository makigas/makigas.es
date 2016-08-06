Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'front#index'

  # These routes should be limited to authorized users.
  resources :playlists, path: 'series', only: [:new, :create, :edit, :update, :destroy]
  resources :videos, only: [:new, :create, :edit, :update, :destroy]

  # These are the public routes for my application.
  get :videos, to: 'videos#index'
  resources :playlists, path: 'series', only: [:index, :show] do
    resources :videos, path: '/', only: [:show]
  end
end
