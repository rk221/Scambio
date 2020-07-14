class ItemTradeQueuesController < ApplicationController
    include Errors 
    include Users

    def index
        @item_trade_queues = ItemTradeQueue.trade_under_purchases(current_user.id).order("item_trade_queues.updated_at DESC").decorate
    end

    def show 
        @item_trade_queue = current_user.item_trade_queues.find(params[:id]).decorate
        return redirect_to_error t('flash.item_trades.end_item_trade') unless @item_trade_queue.item_trade.enable
        return redirect_to_error t('flash.item_trades.evaluated_item_trade') if @item_trade_queue.item_trade_detail&.sale_popuarity

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id, sender_is_seller: false)
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end
        
        @user = current_user.decorate
    end

    def buy # アイテムトレード一覧から購入を押すことで飛んでくる
        item_trade_queue = ItemTradeQueue.find(params[:id])

        return redirect_back(fallback_location: root_path, warning: t('.another_user_already_exists')) if item_trade_queue.user_id # 既に購入待ちが居る場合
        return redirect_to redirect_to_permit_error if confirm_user(item_trade_queue.item_trade) # ユーザIDと売却者ユーザIDが一致していると不正

        if item_trade_queue.buy(current_user.id)
            redirect_to action: 'show', id: item_trade_queue.id, warning: t('.success_message')
        else
            redirect_to_error
        end
    end
end
