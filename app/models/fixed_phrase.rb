class FixedPhrase < ApplicationRecord
    belongs_to :user

    validates :user_id, presence: true
    validates :name, presence: true, length: {maximum: 30}
    validates :text, presence: true, length: {maximum: 100}
end
