class Users::ItemTradeQueuesController < UsersController
    before_action :user_auth

    def index
        @item_trade_queues = ItemTradeQueue.trade_under_purchases(current_user.id).order("item_trade_queues.updated_at DESC").decorate
    end

    def show 
        @item_trade_queue = current_user.item_trade_queues.find(params[:id]).decorate
        return redirect_to_error t('flash.item_trades.end_item_trade') unless @item_trade_queue.item_trade.enable                       # 取引が有効ではない
        return redirect_to_error t('flash.item_trades.evaluated_item_trade') if @item_trade_queue.item_trade_detail&.sale_popuarity     # 既に取引を評価して終了している

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id, sender_is_seller: false)
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end
        
        @user = current_user.decorate
    end

    def create 
        @item_trade_queue = current_user.item_trade_queues.new(buy_params)
        if @item_trade_queue.buy
            redirect_to action: :show, id: @item_trade_queue.id, warning: t('.success_message')
        else
            redirect_to_error
        end
    end

    private 
    def buy_params
        params.require(:item_trade_queue).permit(:item_trade_id)
    end
end
