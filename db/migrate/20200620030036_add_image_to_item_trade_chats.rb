class AddImageToItemTradeChats < ActiveRecord::Migration[6.0]
  def change
    add_column :item_trade_chats, :image, :string
  end
end
