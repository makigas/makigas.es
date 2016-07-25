Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'front#index'
  
  get :videos, to: 'videos#index'

  resources :playlists, path: 'series', only: [:new, :create, :edit, :update, :destroy]
  
  resources :playlists, path: 'series', only: [:index, :show] do
    resources :videos, path: '/', only: [:show]
  end
end
