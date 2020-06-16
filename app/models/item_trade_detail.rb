class ItemTradeDetail < ApplicationRecord
    belongs_to :item_trade_queue
    has_many :item_trade_chat

    validates :buy_popuarity, inclusion: {in: [3, 0, -1]}, allow_nil: true
    validates :sale_popuarity, inclusion: {in: [3, 0, -1]}, allow_nil: true
    validates :item_trade_queue_id, presence: true

    def last_update_1_hour_passed?
        updated_at.since(1.hours) < Time.zone.now
    end
end
