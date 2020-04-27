class Game < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    
    mount_uploader :image_icon, ImageUploader
end
