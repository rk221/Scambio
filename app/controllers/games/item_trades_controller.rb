class Games::ItemTradesController < ApplicationController
    include Users

    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        # 検索に会うもの + 有効な取引 + 購入されていない取引 + ゲームに一致している
        @item_trades = search_item_trades(@q.result(distinct: true), search_params).enabled.includes(:enable_item_trade_queue).joins(:game).where(item_trade_queues: {user_id: nil, enable_flag: true}, game_id: params[:game_id])
        @page_item_trades = @item_trades.page(params[:page])
        @item_trades = @page_item_trades.includes(:user, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank).decorate
        @selectable_item_genres = ItemGenreGame.selectable_item_genres(params[:game_id])
    end

    def new 
        game = Game.find(params[:game_id])
        @selectable_item_genres = ItemGenreGame.selectable_item_genres(game.id)

        @regist_item_trade_form = RegistItemTradeForm.new(game_id: game.id)
    end

    def create 
        @regist_item_trade_form = RegistItemTradeForm.new(regist_item_trade_form_params)

        if @regist_item_trade_form.save 
            redirect_to user_user_item_trades_path(id: @regist_item_trade_form.id, user_id: current_user.id), notice: t('flash.regist')
        else
            @selectable_item_genres = ItemGenreGame.selectable_item_genres(@regist_item_trade_form.game_id)
            render :new
        end
    end

    def edit 
        @item_trade = current_user.item_trades.find(params[:id])
    end

    def update 
        @item_trade = current_user.item_trades.find(params[:id])
        
        # 取引を再登録
        if @item_trade.re_regist(update_item_trade_params)
            redirect_to user_user_item_trade_path(id: @item_trade.id, user_id: current_user.id), notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @item_trade = current_user.item_trades.find(params[:id])
        @item_trade.disable_trade
        redirect_to user_user_item_trades_path(user_id: current_user.id), notice: t('flash.destroy')
    end

    private
    def regist_item_trade_form_params 
        params.require(:regist_item_trade_form)
        .permit(:buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :numeric_of_trade_deadline, :buy_item_genre_id, :sale_item_genre_id)
        .merge(user_id: current_user.id, user_game_rank_id: UserGameRank.find_or_create_by(user_id: current_user.id, game_id: params[:game_id]).id, game_id: params[:game_id])
    end

    def update_item_trade_params 
        params.require(:item_trade).permit(:buy_item_quantity, :sale_item_quantity, :numeric_of_trade_deadline)
    end

    # 検索フォームのパラメータ（ソートも含む)
    def search_params
        params.require(:q).permit(:buy_item_name, :sale_item_name, :buy_item_item_genre_id, :sale_item_item_genre_id, :sorts)
    end
    #　自作の検索を行う
    def search_item_trades (item_trades, search_params) 
        item_trades = item_trades.search_buy_item_name(search_params[:buy_item_name]) if search_params[:buy_item_name].present?
        item_trades = item_trades.search_sale_item_name(search_params[:sale_item_name]) if search_params[:sale_item_name].present?
        item_trades = item_trades.search_buy_item_genre_id(search_params[:buy_item_item_genre_id]) if search_params[:buy_item_item_genre_id].present?
        item_trades = item_trades.search_sale_item_genre_id(search_params[:sale_item_item_genre_id]) if search_params[:sale_item_item_genre_id].present?
        return item_trades
    end
end
