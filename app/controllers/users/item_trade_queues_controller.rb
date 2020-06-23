class Users::ItemTradeQueuesController < UsersController
    before_action :user_auth
    
    def index
        @item_trade_queues = ItemTradeQueue
            .exist_user_enabled
            .where(item_trade_queues: {user_id: current_user.id})
            .includes({item_trade: [:user, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank, :game]}, :item_trade_detail)
            .order("item_trade_queues.updated_at DESC").decorate
    end

    def show 
        @item_trade_queue = ItemTradeQueue.find(params[:id]).decorate
        redirect_to root_path, warning: t('flash.error') unless @item_trade_queue.user_id == current_user.id && @item_trade_queue.enable_flag

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id, sender_is_seller: false)
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end
        
        @user = current_user.decorate
    end

    def buy # アイテムトレード一覧から購入を押すことで飛んでくる
        item_trade_queue = ItemTradeQueue.find(params[:id])

        return redirect_back(fallback_location: root_path, warning: t('.another_user_already_exists')) if item_trade_queue.user_id # 既に購入待ちが居る場合
        return redirect_to root_path, t('flash.error') if item_trade_queue.item_trade.user_id == current_user.id # ユーザIDと購入者ユーザIDが一致していると不正

        if item_trade_queue.update(user_id: current_user.id, lock_version: item_trade_queue.lock_version)
            # 成立メッセージを相手に送信
            UserMessagePost.create_message_sell!(item_trade_queue)
            # ゲームランクを生成する user_idとgame_idで一意でなければvalidationで弾く。
            user_game_rank = UserGameRank.new(user_id: current_user.id, game_id: item_trade_queue.item_trade.game_id)
            user_game_rank.save

            return redirect_to action: 'show', id: item_trade_queue.id, user_id: current_user.id, warning: t('.success_message')
        else
            return redirect_to root_path, warning: t('flash.error')
        end
    end
end
