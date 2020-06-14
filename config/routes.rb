Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:show] do 
    scope module: :users do
      resources :user_item_trades, only: [:index, :show]
      post '/user_item_trade/:id/respond' => 'user_item_trades#respond', as: 'respond_user_item_trade'

      resources :item_trade_queues, only: [:index, :show]
      post '/item_trade_queues/:id/buy' => 'item_trade_queues#buy', as: 'buy_item_trade_queue'
    end
  end

  namespace :admin do
    resources :games
    resources :item_genres
    resources :item_genre_games, param: :game_id, only: [:index]
    post '/item_genre_games/enable/:id' => 'item_genre_games#enable', as: 'enable_item_genre_game'
    post '/item_genre_games/disable/:id' => 'item_genre_games#disable', as: 'disable_item_genre_game'
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

  get '/item_trade_details/:id/edit_buy' => 'item_trade_details#edit_buy', as: 'edit_buy_item_trade_detail'
  get '/item_trade_details/:id/edit_sale' => 'item_trade_details#edit_sale', as: 'edit_sale_item_trade_detail'
  patch '/item_trade_details/:id/edit_buy' => 'item_trade_details#buy_evaluate', as: 'buy_evaluate_item_trade_detail'
  patch '/item_trade_details/:id/edit_sale' => 'item_trade_details#sale_evaluate', as: 'sale_evaluate_item_trade_detail'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#show'
end
