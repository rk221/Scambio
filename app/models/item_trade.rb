class ItemTrade < ApplicationRecord
    belongs_to :user
    belongs_to :game

    belongs_to :buy_item, class_name: "Item", foreign_key: "buy_item_id"
    belongs_to :sale_item, class_name: "Item", foreign_key: "sale_item_id"

    has_many :item_trade_detials
    has_many :buy_users, through: :item_trade_detials, source: :buy_user

    validates :buy_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :sale_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}

    validates :user_id, presence: true
    validates :game_id, presence: true
    validates :buy_item_id, presence: true
    validates :sale_item_id, presence: true
    validates :enable_flag, inclusion: {in: [true, false]}
    validates :trade_deadline, presence: true
end
