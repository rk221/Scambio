class Users::ItemTradeQueuesController < UsersController
    before_action :user_auth
    
    def index
        @item_trade_queues = Users::ItemTradeQueueDecorator.decorate_collection(
            ItemTradeQueue.exist_user_enabled.where(item_trade_queues: {user_id: current_user.id})
            .includes(:item_trade, :item_trade_detail)
            .order("item_trade_queues.updated_at DESC"))
    end

    def show 
        @item_trade_queue = ItemTradeQueue.find(params[:id])
        redirect_to root_path, warning: t('flash.error') unless @item_trade_queue.user_id == current_user.id && @item_trade_queue.enable_flag

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id, sender_is_seller: false)
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end
    end

    def buy # アイテムトレード一覧から購入を押すことで飛んでくる
        item_trade_queue = ItemTradeQueue.find(params[:id])

        return redirect_back(fallback_location: root_path, warning: t('.another_user_already_exists')) if item_trade_queue.user_id # 既に購入待ちが居る場合
        return redirect_to root_path, t('flash.error') if item_trade_queue.item_trade.user_id == current_user.id # ユーザIDと購入者ユーザIDが一致していると不正
        # 既に同じユーザに購入されている場合、showに飛ばした方がいいかも

        if item_trade_queue.update(user_id: current_user.id, lock_version: item_trade_queue.lock_version)
            return redirect_to action: 'show', id: item_trade_queue.id, user_id: current_user.id, warning: t('.success_message')
        else
            return redirect_to root_path, warning: t('flash.error')
        end
    end
end
