Rails.application.routes.draw do
  resources :restaurants
  post 'search' => 'restaurants#search'
  get 'search' => 'restaurants#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
