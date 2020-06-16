class ItemTradeChat < ApplicationRecord
    belongs_to :item_trade_detail

    validates :sender_is_seller, inclusion: {in: [true, false]}
    validates :item_trade_detail_id, presence: true
    validates :message, presence: true, length: {maximum: 200}
end
