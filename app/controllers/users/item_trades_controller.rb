class Users::ItemTradesController < UsersController
    before_action :user_auth

    # ユーザの取引一覧
    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        # 検索の結果 + ユーザに一致する
        @page_item_trades = @q.result(distinct: true)
            .includes(:item_trade_queue, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank, :game)
            .where(user_id: current_user.id) # ユーザの物だけ抽出する
            .page(params[:page])
        @item_trades = @page_item_trades.decorate
        # ジャンル一覧を取得
        @selectable_item_genres = ItemGenre.all
    end

    def show 
        @item_trade = current_user.item_trades.find(params[:id]).decorate
        return redirect_to_error t('flash.item_trades.end_item_trade') unless @item_trade.enable

        if @item_trade&.item_trade_queue&.approve
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade.item_trade_queue.item_trade_detail.id) 
            @item_trade_chats = @item_trade.item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end

        @user = current_user.decorate
    end

    def respond # 購入応答 POST で 売却可否を受け取る
        @item_trade = current_user.item_trades.find(params[:id])
        
        if @item_trade.respond(respond_params)
            if @item_trade.item_trade_queue.approve # 成立→引き続き詳細画面 不成立→編集画面
                redirect_to action: :show, id: @item_trade.id, user_id: current_user.id, notice: t('.approve')
            else
                redirect_to edit_game_item_trade_path(id: @item_trade.id, game_id: @item_trade.game_id), notice: t('.disapprove')
            end
        else
            redirect_to_error 
        end
    end


    # 相手の取引評価が行われない場合、強制更新、強制終了を行う
    def forced
        @item_trade = current_user.item_trades.find(params[:id])
        return redirect_to_permit_error unless  @item_trade.item_trade_queue.item_trade_detail&.buy_popuarity && @item_trade.item_trade_queue.item_trade_detail.last_update_1_hour_passed?
        
        return redirect_to_permit_error unless @item_trade.forced # 強制終了 & メッセージ送信

        if params[:to_edit]
            redirect_to edit_game_item_trade_path(id: @item_trade.id, game_id: @item_trade.game_id), notice: t('flash.destroy')
        else
            redirect_to action: :index, user_id: current_user.id, notice: t('flash.destroy')
        end
    end

    private 

    def respond_params
        params[:approve] == 'true'
    end

    # 検索フォームのパラメータ（ソートも含む)
    def search_params
        params.require(:q).permit(:enabled_or_during_trade, :game_title_cont, :custom_buy_item_name_cont, :custom_buy_item_item_genre_id_eq, :custom_sale_item_name_cont, :custom_sale_item_item_genre_id_eq, :sorts)
    end
end
