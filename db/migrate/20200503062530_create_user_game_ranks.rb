class CreateUserGameRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_game_ranks do |t|
      t.integer :rank, null: false, default: 0
      t.integer :trade_count, null: false, default: 0
      t.integer :popularity, null: false, default: 0

      t.references :user, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end

    add_index :user_game_ranks, [:user_id, :game_id], unique: true
  end
end
