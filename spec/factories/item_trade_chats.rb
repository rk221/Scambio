FactoryBot.define do
  factory :item_trade_chat do
    item_trade_detail
    sender_is_seller {true} 
    message {"テストメッセージです"}
  end
end
