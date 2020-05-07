class Item < ApplicationRecord
    belongs_to :item_genre
    belongs_to :game

    validates :name, presence: true, length: {maximum: 30}
    validates :unit_name, length: {maximum: 10}
    validates :item_genre_id, presence: true 
    validates :game_id, presence: true
end
