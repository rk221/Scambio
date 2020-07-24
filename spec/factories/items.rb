FactoryBot.define do
  factory :item do
    name {"テストあいてむ"}
    unit_name {"個"}
    item_genre
    game
  end

  factory :buy_item, class: Item do
    name {"買うテストあいてむ"}
    unit_name {"個"}
    item_genre
    game
  end

  factory :sale_item, class: Item do
    name {"売るテストあいてむ"}
    unit_name {"個"}
    item_genre
    game
  end
end
