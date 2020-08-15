class RemoveEnableItemTradeIdFromItemTrades < ActiveRecord::Migration[6.0]
  def change
    remove_reference :item_trades, :enable_item_trade_queue, foreign_key: {to_table: :item_trade_queues}
  end
end
