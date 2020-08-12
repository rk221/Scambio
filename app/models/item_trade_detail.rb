class ItemTradeDetail < ApplicationRecord
    belongs_to :item_trade_queue
    has_many :item_trade_chats, dependent: :destroy

    validates :buy_popuarity, inclusion: {in: [3, 0, -1]}, allow_nil: true
    validates :sale_popuarity, inclusion: {in: [3, 0, -1]}, allow_nil: true
    validates :item_trade_queue_id, presence: true

    def last_update_1_hour_passed?
        updated_at.since(1.hours) < Time.zone.now
    end

    # 購入者を評価する
    def buy_evaluate(buy_evaluate_params)
        self.transaction do
            update!(buy_evaluate_params)
            if self.sale_popuarity # 両者評価しているなら取引を終了させる
                item_trade_queue.item_trade.disable_trade! 
            end
            # 購入側のRANKを更新
            UserGameRank.find_by(user_id: item_trade_queue.user_id, game_id: item_trade_queue.item_trade.game_id).buy_item_trade_update!(self.buy_popuarity)
            # 自分のバッジを更新
            UserBadge.create_to_can_attach!(item_trade_queue.item_trade.user_id, item_trade_queue.item_trade.game_id)
            # 相手のバッジを更新
            UserBadge.create_to_can_attach!(item_trade_queue.user_id, item_trade_queue.item_trade.game_id)
        end
        true
    rescue
        false
    end

    # 売却者を評価する
    def sale_evaluate(sale_evaluate_params)
        self.transaction do
            update!(sale_evaluate_params)
            if self.buy_popuarity # 両者評価しているなら取引を終了させる
                item_trade_queue.item_trade.disable_trade! 
            end
            # 売却側のRANKを更新
            UserGameRank.find_by(user_id: item_trade_queue.item_trade.user_id, game_id: item_trade_queue.item_trade.game_id).sale_item_trade_update!(self.sale_popuarity)
            # 自分のバッジを更新
            UserBadge.create_to_can_attach!(item_trade_queue.user_id, item_trade_queue.item_trade.game_id)
            # 相手のバッジを更新
            UserBadge.create_to_can_attach!(item_trade_queue.item_trade.user_id, item_trade_queue.item_trade.game_id)
        end
        true
    rescue
        false
    end
end
