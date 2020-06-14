class ChangeTradeCountOfUserGameRanks < ActiveRecord::Migration[6.0]
  def up
    remove_column :user_game_ranks, :trade_count

    add_column :user_game_ranks, :buy_trade_count, :integer, null: false, default: 0
    add_column :user_game_ranks, :sale_trade_count, :integer, null: false, default: 0
  end

  def down 
    add_column :user_game_ranks, :trade_count

    remove_column :user_game_ranks, :buy_trade_count, :integer, null: false, default: 0
    remove_column :user_game_ranks, :sale_trade_count, :integer, null: false, default: 0
  end
end
