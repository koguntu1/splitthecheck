Rails.application.routes.draw do
  devise_for :users
  resources :restaurants
  root 'restaurants#index'
  post 'search' => 'restaurants#search'
  get 'search' => 'restaurants#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
