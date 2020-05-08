class CreateItemTradeDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :item_trade_details do |t|
      t.integer :buy_user_popuarity, null: false, default: 0
      t.integer :sale_user_popuarity, null: false, default: 0

      t.references :buy_user, foreign_key: {to_table: :users}
      t.references :item_trade, foreign_key: true
      
      t.timestamps
    end
  end
end
