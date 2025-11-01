# frozen_string_literal: true

root to: 'front#index'

# Explorer
resources :tags, path: 'temas', only: %i[index]
get '/explorar(/:type)(/tema/:tag)', to: 'search#index', as: :search,
                                     constraints: { type: /videos|cursos/ }
resources :videos, only: :index, format: :atom

# Videos
resources :playlists, path: 'series', only: %i[index show] do
  resources :videos, path: '/', only: :show
end

# Early access.
get '/early' => redirect('http://early.makigas.es', status: 302)
get '/early/videos', to: 'videos#early', format: :json

# Pages
get :terms, path: 'terminos', to: 'pages#terms'
get :privacy, path: 'privacidad', to: 'pages#privacy'
get :disclaimer, path: 'responsabilidades', to: 'pages#disclaimer'
get :cookies, to: 'pages#cookies'
get :discord, to: 'pages#discord'
get '/bootcamps-no-autorizados', to: 'pages#bootcamps'
get :dnt, to: 'pages#dnt'

# Video ID redirection
get '/v/:id', to: 'videos#find_by_id', as: :video_by_id
