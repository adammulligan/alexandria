Rails.application.routes.draw do
  root to: 'books#index'

  resources :books
  get '/search', to: 'search#index'
end
