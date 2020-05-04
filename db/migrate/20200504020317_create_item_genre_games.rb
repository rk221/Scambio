class CreateItemGenreGames < ActiveRecord::Migration[6.0]
  def change
    create_table :item_genre_games do |t|
      t.boolean :enable_flag, null: false, default: false

      t.references :item_genre, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end

    add_index :item_genre_games, [:item_genre_id, :game_id], unique: true
  end
end
