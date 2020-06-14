class ItemTradeQueue < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :item_trade
    has_one :item_trade_detail
    has_one :enable_item_trade, class_name: "ItemTrade", foreign_key: "enable_item_trade_queue_id"

    validates :item_trade_id, presence: true
    validates :enable_flag, inclusion: {in: [true, false]}
    validates :establish_flag, inclusion: {in: [true, false, nil]}

    scope :exist_user_enabled, -> {where("item_trade_queues.enable_flag = true AND item_trade_queues.user_id IS NOT NULL")}
end
