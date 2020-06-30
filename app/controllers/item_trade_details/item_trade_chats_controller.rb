class ItemTradeDetails::ItemTradeChatsController < ApplicationController
    def create
        @item_trade_chat = ItemTradeChat.create!(item_trade_chat_params)
        # サブスクライバーにバルーン部分を追記するHTMLを送信
        ItemTradeChatChannel.broadcast_to("#{params[:item_trade_detail_id]}", message: @item_trade_chat.template) 
    end

    private
    def item_trade_chat_params
        params.require(:item_trade_chat).permit(:item_trade_detail_id, :sender_is_seller, :message, :image)
    end
end
