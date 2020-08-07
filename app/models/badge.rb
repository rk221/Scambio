class Badge < ApplicationRecord
    belongs_to :game

    validates :game_id, presence: true
    validates :name, presence: true, uniqueness: true, length: {maximum: 30}
    validates :item_trade_count_condition, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :rank_condition, presence: true, numericality: {greater_than_or_equal_to: -2, less_than_or_equal_to: 4}
end
