Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]

  namespace :admin do
    resources :games
  end

  resources :codes, only: [:index]
  namespace :codes do
    resources :nintendo_friend_codes, only: [:new, :create, :edit, :update, :destroy]
    resources :play_station_network_ids, only: [:new, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#show'
end
