class ChangeNotNullItemTradeQueueIdToItemTradeDetails < ActiveRecord::Migration[6.0]
  def change
    change_column_null :item_trade_details, :item_trade_queue_id, true
  end
end
