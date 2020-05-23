class CreateItemTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :item_trades do |t|
      t.integer :buy_item_quantity, null: false
      t.integer :sale_item_quantity, null: false

      t.boolean :enable_flag, null: false
      t.datetime :trade_deadline, null: false

      t.references :user, foreign_key: true, null: false
      t.references :game, foreign_key: true, null: false

      t.references :buy_item, foreign_key: {to_table: :items}, null: false
      t.references :sale_item, foreign_key: {to_table: :items}, null: false

      t.timestamps
    end
  end
end
