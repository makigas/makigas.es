Rails.application.routes.draw do
  devise_for :users
  root to: 'front#index'

  get :videos, to: 'videos#index'
  resources :playlists, path: 'series', only: [:index, :show] do
    resources :videos, path: '/', only: [:show]
  end
  resources :topics, only: [:index, :show]
end
