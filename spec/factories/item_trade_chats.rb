FactoryBot.define do
  factory :item_trade_chat do
    item_trade_detail {1}
    sender_is_seller {true} 
    message {"テストメッセージです"}
  end
end
