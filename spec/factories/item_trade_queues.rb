FactoryBot.define do
  factory :item_trade_queue do
    user_id {1}
    item_trade_id {1}
    enable_flag {true}
    establish_flag {false}
  end
end
