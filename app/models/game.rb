class Game < ApplicationRecord
    has_many :user_game_ranks
    has_many :users, through: :user_game_ranks

    has_many :item_genre_games
    has_many :item_genres, through: :item_genre_games
    
    validates :title, presence: true, uniqueness: true
    
    mount_uploader :image_icon, ImageUploader
end
