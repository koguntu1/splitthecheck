Rails.application.routes.draw do
  devise_for :users
  resources :restaurants
  root 'restaurants#index'
  post 'search' => 'restaurants#search'
  get 'search' => 'restaurants#index'
  get 'vote_history' => 'restaurants#vote_history'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
