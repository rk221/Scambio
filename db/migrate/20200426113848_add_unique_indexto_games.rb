class AddUniqueIndextoGames < ActiveRecord::Migration[6.0]
  def change
    add_index :games, :title, unique: true
  end
end
