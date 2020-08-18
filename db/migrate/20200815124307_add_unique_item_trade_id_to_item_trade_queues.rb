class AddUniqueItemTradeIdToItemTradeQueues < ActiveRecord::Migration[6.0]
  def up
    change_column :item_trade_queues, :item_trade_id, :integer, unique: true, null: false
  end

  def down 
    change_column :item_trade_queues, :item_trade_id, :integer, unique: false, null: false
  end
end
