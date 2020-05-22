class ItemTradeDetail < ApplicationRecord
    belongs_to :buy_user, class_name: "User", foreign_key: "buy_user_id"
    belongs_to :item_trade

    validates :buy_user_popuarity, presence: true, numericality: {only_integer: true}
    validates :sale_user_popuarity, presence: true, numericality: {only_integer: true}
    validates :buy_user_id, presence: true
    validates :item_trade_id, presence: true
end
