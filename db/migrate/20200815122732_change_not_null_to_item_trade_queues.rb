class ChangeNotNullToItemTradeQueues < ActiveRecord::Migration[6.0]
  def change
    change_column_null :item_trade_queues, :user_id, false
    change_column_null :item_trade_queues, :approve, false
    change_column_default :item_trade_queues, :approve, false
  end
end
