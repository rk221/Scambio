class ItemTradeQueue < ApplicationRecord
    belongs_to :user
    belongs_to :item_trade

    validates :user_id, presence: true
    validates :item_trade_id, presence: true
    validates :end_flag, inclusion: {in: [true, false]}
end
