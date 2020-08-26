class Item < ApplicationRecord
    belongs_to :item_genre
    belongs_to :game
    
    has_many :buy_items, class_name: "ItemTrade", foreign_key: "buy_item_id"
    has_many :sale_items, class_name: "ItemTrade", foreign_key: "sale_item_id"

    has_many :buy_users, through: :buy_items, source: :user
    has_many :buy_games, through: :buy_items, source: :game
    has_many :sale_users, through: :sale_items, source: :user
    has_many :sale_games, through: :sale_items, source: :game

    validates :name, presence: true, length: {maximum: 30}
    validates :unit_name, length: {maximum: 10}
    validates :item_genre_id, presence: true 
    validates :game_id, presence: true

    # アイテムトレード購入で使われているアイテム数を返す
    def registered_count_buy_item_trades
        ItemTrade.where(buy_item_id: self.id).size
    end

    # アイテムトレード売却で使われているアイテム数を返す
    def registered_count_sale_item_trades
        ItemTrade.where(sale_item_id: self.id).size
    end
end
