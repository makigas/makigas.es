# frozen_string_literal: true

Rails.application.routes.draw do
  # Application error routes
  get '/404', to: 'error#not_found', via: :all
  get '/406', to: 'error#not_acceptable', via: :all
  get '/422', to: 'error#unprocessable_entity', via: :all
  get '/500', to: 'error#internal_server_error', via: :all

  # Legacy feed URLs, must come first or there will be conflicts.
  get '/videos/feed' => redirect('/videos.atom')
  get '/temas/:topic/feed' => redirect('/explorar/tema/%{topic}')
  get '/series/:playlist/feed' => redirect('/series/%{playlist}.atom')

  draw(:dashboard)
  draw(:app)
  draw(:legacy)

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
end
