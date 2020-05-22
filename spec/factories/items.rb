FactoryBot.define do
  factory :item do
    name {"テストあいてむ"}
    unit_name {"個"}
    item_genre_id {1}
    game_id {1}
  end

  factory :buy_item, class: Item do
    name {"買うテストあいてむ"}
    unit_name {"個"}
    item_genre_id {1}
    game_id {1}
  end

  factory :sale_item, class: Item do
    name {"売るテストあいてむ"}
    unit_name {"個"}
    item_genre_id {1}
    game_id {1}
  end
end
