class CreateItemTradeDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :item_trade_details do |t|
      t.references :item_trade_queue, foreign_key: true, null: false

      t.integer :buy_popuarity
      t.integer :sale_popuarity
      
      t.timestamps
    end
  end
end
