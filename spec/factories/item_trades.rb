FactoryBot.define do
  factory :item_trade do  
    user
    game
    buy_item_quantity {1}
    sale_item_quantity {1}
    buy_item
    sale_item
    enable{false}
    numeric_of_trade_deadline{10}
    user_game_rank
  end
end
