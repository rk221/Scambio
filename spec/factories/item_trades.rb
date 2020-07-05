FactoryBot.define do
  factory :item_trade do  
    user_id {1}
    game_id {1}
    buy_item_quantity {1}
    sale_item_quantity {1}
    buy_item_id {0}
    sale_item_id {0}
    enable_flag{false}
    numeric_of_trade_deadline{10}
    user_game_rank{1}
  end
end
