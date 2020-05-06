class ItemGenre < ApplicationRecord
    has_many :item_genre_games
    has_many :games, through: :item_genre_games

    validates :name, presence: true, length: {maximum: 30}, uniqueness: true
    validates :default_unit_name, presence: true, length: {maximum: 10}
end
