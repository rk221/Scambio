FactoryBot.define do
  factory :item_trade do  
    user_id {1}
    game_id {1}
    buy_item_quantity {1}
    sale_item_quantity {1}
    buy_item_id {0}
    sale_item_id {0}
    enable_flag{false}
    trade_deadline{Time.now}
  end
end
