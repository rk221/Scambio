FactoryBot.define do
  factory :item_trade_queue do
    user
    item_trade
    approve {false}
  end
end
