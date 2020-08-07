FactoryBot.define do
  factory :user_badge do
    user
    badge
    wear {false}
  end
end
