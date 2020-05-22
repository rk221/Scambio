class ItemTrade < ApplicationRecord
    belongs_to :user
    belongs_to :game

    belongs_to :buy_item, class_name: "Item", foreign_key: 'buy_item_id'
    belongs_to :sale_item, class_name: "Item", foreign_key: 'sale_item_id'

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

    scope :enabled, -> {where("enable_flag = true and trade_deadline > ?", Time.zone.now)}

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
end
