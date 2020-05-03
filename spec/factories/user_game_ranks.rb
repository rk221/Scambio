FactoryBot.define do
  factory :user_game_rank do
    rank {0}
    trade_count {0}
    popularity {0}
    user_id {1}
    game_id {1}
  end
end
