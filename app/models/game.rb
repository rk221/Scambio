class Game < ApplicationRecord
    validates :title, presence: true
    
    mount_uploader :image_icon, ImageUploader
end
