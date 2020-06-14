class ItemTrade < ApplicationRecord
    belongs_to :user
    belongs_to :game

    belongs_to :buy_item, class_name: "Item", foreign_key: 'buy_item_id'
    belongs_to :sale_item, class_name: "Item", foreign_key: 'sale_item_id'

    has_many :item_trade_queues
    has_many :item_trade_queue_users, through: :item_trade_queues, source: :user

    belongs_to :enable_item_trade_queue, class_name: "ItemTradeQueue", foreign_key: "enable_item_trade_queue_id", optional: true

    validates :buy_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :sale_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}

    validates :user_id, presence: true
    validates :game_id, presence: true
    validates :buy_item_id, presence: true
    validates :sale_item_id, presence: true
    validates :enable_flag, inclusion: {in: [true, false]}
    validates :trade_deadline, presence: true
    # 取引が有効化どうか
    scope :enabled, -> {where("item_trades.enable_flag = true and trade_deadline > ?", Time.zone.now)}
    scope :disabled, -> {where("item_trades.enable_flag = false or trade_deadline <= ?", Time.zone.now)}

    # 取引が有効な時
    scope :enabled_or_during_trade, -> {eager_load(:item_trade_queues).where("item_trades.enable_flag = true AND (item_trades.trade_deadline > ? OR item_trade_queues.user_id IS NOT NULL)", Time.zone.now)}
    # 有効なキューが存在するかどうか(取引中の状態があるかどうか（待ちを含む）)
    scope :exist_queues, -> {joins(:item_trade_queues).where("item_trade_queues.enable_flag = true AND item_trade_queues.user_id IS NOT NULL")}

    scope :left_join_buy_item, -> {
        joins("LEFT OUTER JOIN items as buy_items ON item_trades.buy_item_id = buy_items.id")
    }

    scope :left_join_sale_item, -> {
        joins("LEFT OUTER JOIN items as sale_items ON item_trades.sale_item_id = sale_items.id")
    }

    # 上記の結合を行なってから検索を行うこと！
    scope :search_buy_item_name, -> (search_name){
        where('buy_items.name like ?', "%" + search_name + "%")
    }
    scope :search_buy_item_genre_id, -> (search_genre_id){
        where('buy_items.item_genre_id = ?', search_genre_id)
    }
    scope :search_sale_item_name, -> (search_name){
        where('sale_items.name like ?', "%" + search_name + "%")
    }
    scope :search_sale_item_genre_id, -> (search_genre_id){
        where('sale_items.item_genre_id = ?', search_genre_id)
    }

    def self.ransackable_scopes(auth_object = nil)
        %i(enabled_or_during_trade)
    end
end
