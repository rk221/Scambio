class CreateItemTradeQueues < ActiveRecord::Migration[6.0]
  def change
    create_table :item_trade_queues do |t|
      t.references :item_trade, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :end_flag, null: false, default: true
      t.timestamps
    end
  end
end
