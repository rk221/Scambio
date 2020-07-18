FactoryBot.define do
  factory :item_trade_queue do
    user
    item_trade
    establish {false}
  end
end
