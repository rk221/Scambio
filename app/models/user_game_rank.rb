class UserGameRank < ApplicationRecord
    belongs_to :user
    belongs_to :game

    validates :user_id, presence: true, uniqueness: {scope: :game_id}
    validates :game_id, presence: true

    validates :rank, presence: true, numericality: {greater_than_or_equal_to: -2, less_than_or_equal_to: 4}
    validates :trade_count, presence: true, numericality: {greater_than_or_equal_to: 0}
    validates :popularity, presence: true, numericality: {greater_than_or_equal_to: -100, less_than_or_equal_to: 100}
end
