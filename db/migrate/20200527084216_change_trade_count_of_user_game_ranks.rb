class ChangeTradeCountOfUserGameRanks < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_game_ranks, :trade_count

    add_column :user_game_ranks, :buy_trade_count, :integer, null: false, default: 0
    add_column :user_game_ranks, :sale_trade_count, :integer, null: false, default: 0
  end
end
