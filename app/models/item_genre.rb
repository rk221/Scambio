class ItemGenre < ApplicationRecord
    has_many :item_genre_games, dependent: :destroy
    has_many :item_genre_game_games, through: :item_genre_games, source: :game

    has_many :items, dependent: :destroy
    has_many :item_games, through: :items, source: :game

    validates :name, presence: true, length: {maximum: 30}, uniqueness: true
    validates :default_unit_name, presence: true, length: {maximum: 10}
end
