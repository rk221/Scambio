class AddItemTradeIdFromItemTradeDetails < ActiveRecord::Migration[6.0]
  def change
    add_reference :item_trade_details, :item_trade, foreign_key: true
  end
end
