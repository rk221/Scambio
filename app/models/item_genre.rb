class ItemGenre < ApplicationRecord
    has_many :item_genre_games, dependent: :destroy
    has_many :item_genre_game_games, through: :item_genre_games, source: :game

    has_many :items, dependent: :destroy
    has_many :item_games, through: :items, source: :game

    validates :name, presence: true, length: {maximum: 30}, uniqueness: true
    validates :default_unit_name, presence: true, length: {maximum: 10}

    def save_and_create_item_genre_game
        self.transaction do
            self.save!
            #ItemGenreGameを追加する
            Game.find_each do |game|
                ItemGenreGame.create!(item_genre_id: self.id, game_id: game.id, enable: false) 
            end
        end
        true
    rescue
        false
    end
end
