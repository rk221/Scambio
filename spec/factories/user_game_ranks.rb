FactoryBot.define do
  factory :user_game_rank do
    rank {0}
    buy_trade_count {0}
    sale_trade_count {0}
    popularity {0}
    user
    game
  end
end
