class ItemTradeQueue < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :item_trade
    has_one :item_trade_detail
    has_one :enable_item_trade, class_name: "ItemTrade", foreign_key: "enable_item_trade_queue_id"

    validates :item_trade_id, presence: true
    validates :enable_flag, inclusion: {in: [true, false]}
    validates :establish_flag, inclusion: {in: [true, false, nil]}

    scope :exist_user_enabled, -> {where("item_trade_queues.enable_flag = true AND item_trade_queues.user_id IS NOT NULL")}

    # アイテムトレードに対応する購入待機用枠を作成する
    def self.create_enabled(item_trade_id)
        # 既に、登録済みで、有効な購入待ちが存在する場合
        if item_trade_queues = self.where(item_trade_id: item_trade_id, enable_flag: true)
            # 購入待ちを無効にし、無効にした場合、メッセージを記録する。
            # メッセージ送信（仮）
            item_trade_queues.update_all(enable_flag: false)
        end

        self.create!(item_trade_id: item_trade_id, user_id: nil, enable_flag: true, establish_flag: nil)
    end
end
