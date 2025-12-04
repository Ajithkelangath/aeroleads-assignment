Rails.application.routes.draw do
  root 'calls#index'
  resources :calls, only: [:index, :create]
  resources :posts, only: [:index, :create]
end
