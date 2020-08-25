class Badge < ApplicationRecord
    belongs_to :game
    has_many :user_badges, dependent: :destroy

    validates :game_id, presence: true, uniqueness: {scope: :name}
    validates :name, presence: true, length: {maximum: 30}
    validates :item_trade_count_condition, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :rank_condition, presence: true, numericality: {greater_than_or_equal_to: -2, less_than_or_equal_to: 4}
    validates :description, length: {maximum: 200}

    mount_uploader :image_icon, ImageIconUploader

    def self.game_all_badge_create(badge_params)
        self.transaction do 
            Game.find_each do |game|
                game.badges.create!(badge_params)
            end
        end
        true
    rescue
        false
    end

    def self.game_all_badge_update(before_name, badge_params)
        self.transaction do 
            Badge.where(name: before_name).find_each do |badge|
                badge.update!(badge_params)
            end
        end
        true
    rescue
        false
    end
end
