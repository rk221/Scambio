class ItemTradeDetails::ItemTradeChatsController < ApplicationController
    def create
        @item_trade_chat = ItemTradeChat.new(item_trade_chat_params)
        @item_trade_chat.save!()
        # サブスクライバーにバルーン部分を追記するHTMLを送信
        ItemTradeChatChannel.broadcast_to("#{params[:item_trade_detail_id]}", message: @item_trade_chat.template) 
    end

    private
    def item_trade_chat_params
        params.require(:item_trade_chat).permit(:id, :item_trade_detail_id, :sender_is_seller, :message, :image)
    end
end
