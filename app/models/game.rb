class Game < ApplicationRecord
    has_many :user_game_ranks
    has_many :users, through: :user_game_ranks
    
    validates :title, presence: true, uniqueness: true
    
    mount_uploader :image_icon, ImageUploader
end
