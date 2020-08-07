class UserBadge < ApplicationRecord
    belongs_to :user
    belongs_to :badge

    validates :user_id, presence: true, uniqueness: { scope: :badge_id }
    validates :badge_id, presence: true
    validates :wear, inclusion: {in: [true, false]}
end
