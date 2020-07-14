class ItemGenreGame < ApplicationRecord
    belongs_to :item_genre
    belongs_to :game

    validates :item_genre_id, presence: true, uniqueness: {scope: :game_id}
    validates :game_id, presence: true
    validates :enable, inclusion: {in: [true, false]}

    scope :enabled, -> {where(enable: true)}
    # ゲームに対応するジャンルを取得する
    scope :selectable_item_genres, -> (game_id = nil){enabled.where(game_id: game_id).joins(:item_genre).select(:item_genre_id, :name)}
end
