Rails.application.routes.draw do
  resources :comments
  devise_for :users
  resources :restaurants
  root 'restaurants#index'
  post 'search' => 'restaurants#search'
  get 'search' => 'restaurants#index'
  get 'vote_history' => 'restaurants#vote_history'
  get 'user_summary' => 'comments#summary'
  patch 'favorite' => 'comments#favorite'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
