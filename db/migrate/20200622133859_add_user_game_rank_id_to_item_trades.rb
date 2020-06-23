class AddUserGameRankIdToItemTrades < ActiveRecord::Migration[6.0]
  def change
    add_reference :item_trades, :user_game_rank, foreign_key: true
  end
end
