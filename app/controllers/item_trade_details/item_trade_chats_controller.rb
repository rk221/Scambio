class ItemTradeDetails::ItemTradeChatsController < ApplicationController
    include Users
    
    def sale_create # 売却者側が送信した場合
        return unless confirm_user(ItemTradeDetail.find(params[:item_trade_chat][:item_trade_detail_id]).item_trade_queue.item_trade) # 売却者ユーザ確認

        @item_trade_chat = ItemTradeChat.create!(item_trade_chat_params(true))
        # サブスクライバーにバルーン部分を追記するHTMLを送信
        ItemTradeChatChannel.broadcast_to("#{params[:item_trade_chat][:item_trade_detail_id]}", message: @item_trade_chat.template) 
    end

    def buy_create # 購入者側が送信した場合
        return unless confirm_user(ItemTradeDetail.find(params[:item_trade_chat][:item_trade_detail_id]).item_trade_queue) # 購入者ユーザ確認

        @item_trade_chat = ItemTradeChat.create!(item_trade_chat_params(false))
        # サブスクライバーにバルーン部分を追記するHTMLを送信
        ItemTradeChatChannel.broadcast_to("#{params[:item_trade_chat][:item_trade_detail_id]}", message: @item_trade_chat.template) 
    end

    private
    def item_trade_chat_params(sender_is_seller)
        p = params.require(:item_trade_chat).permit(:item_trade_detail_id, :message, :image).merge(sender_is_seller: sender_is_seller)
        p[:message] = "" if p[:image].present? # 不正にメッセージも格納されている場合、消去する
        p
    end
end
