Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]

  namespace :admin do
    resources :games
    resources :item_genres
    resources :item_genre_games, param: :game_id, only: [:index]
    post '/item_genre_game/enable/:id' => 'item_genre_games#enable', as: 'enable_item_genre_game'
    post '/item_genre_game/disable/:id' => 'item_genre_games#disable', as: 'disable_item_genre_game'
  end

  resources :codes, only: [:index]
  namespace :codes do
    resources :nintendo_friend_codes, only: [:new, :create, :edit, :update, :destroy]
    resources :play_station_network_ids, only: [:new, :create, :edit, :update, :destroy]
  end

  get '/games', to: 'games#index'

  resources :games, only: [:index] do
    resources :item_trades
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#show'
end
