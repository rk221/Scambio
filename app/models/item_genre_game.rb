class ItemGenreGame < ApplicationRecord
    belongs_to :item_genre
    belongs_to :game

    validates :item_genre_id, presence: true, uniqueness: {scope: :game_id}
    validates :game_id, presence: true

    validates :enable_flag, inclusion: {in: [true, false]}
    scope :enabled, -> {
        where('enable_flag = TRUE')
    }
end
