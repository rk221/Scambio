FactoryBot.define do
  factory :badge do
    game
    name {"テストバッジ"}
    item_trade_count_condition {1}
    rank_condition {1}
    description {"これはテストバッジの説明です。"}
  end
end
