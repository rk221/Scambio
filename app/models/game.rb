class Game < ApplicationRecord
    has_many :user_game_ranks, dependent: :destroy
    has_many :users, through: :user_game_ranks

    has_many :item_genre_games, dependent: :destroy
    has_many :item_genre_game_item_genres, through: :item_genre_games, source: :item_genre

    has_many :items
    has_many :item_item_genres, through: :items, source: :item_genre

    has_many :item_trades, dependent: :destroy
    has_many :item_trade_users, through: :item_trades, source: :user
    has_many :buy_items, through: :item_trades, source: :buy_item
    has_many :sale_items, through: :item_trades, source: :sale_item
    
    validates :title, presence: true, uniqueness: true
    
    mount_uploader :image_icon, ImageUploader


    def save_and_create_item_genre_game
        self.transaction do
            self.save!
            #ItemGenreGameを追加する
            ItemGenre.find_each do |item_genre|
                ItemGenreGame.create!(item_genre_id: item_genre.id, game_id: self.id, enable: false) 
            end
        end
        true
    rescue
        false
    end
end
