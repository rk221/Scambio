class CreateItemTradeChats < ActiveRecord::Migration[6.0]
  def change
    create_table :item_trade_chats do |t|
      t.references :item_trade_detail, foreign_key: true, null: false
      t.boolean :sender_is_seller, null: false
      t.string :message, null: false, limit: 200

      t.timestamps
    end
  end
end
