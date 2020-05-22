class Game < ApplicationRecord
    has_many :user_game_ranks
    has_many :users, through: :user_game_ranks

    has_many :item_genre_games, dependent: :destroy
    has_many :item_genres, through: :item_genre_games

    has_many :items, dependent: :destroy
    has_many :item_genres, through: :items

    has_many :item_trades
    has_many :item_trade_users, through: :item_trades, source: :user
    has_many :buy_items, through: :item_trades, source: :buy_item
    has_many :sale_items, through: :item_trades, source: :sale_item
    
    validates :title, presence: true, uniqueness: true
    
    mount_uploader :image_icon, ImageUploader
end
