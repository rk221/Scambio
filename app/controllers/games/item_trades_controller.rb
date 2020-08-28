class Games::ItemTradesController < ApplicationController
    include Users

    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        # 検索の結果 + 取引が有効 + 購入されていない取引 + ゲームに一致している
        @page_item_trades = @q.result(distinct: true)
            .can_buy # 購入できる取引
            .includes(:game, :user, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank)
            .where(game_id: params[:game_id]) #ゲーム一致
            .page(params[:page])
        @item_trades = @page_item_trades.decorate
        @selectable_item_genres = ItemGenreGame.item_genres_that_can_be_used_in_games(params[:game_id])
    end

    def new 
        game = Game.find(params[:game_id])
        @selectable_item_genres = ItemGenreGame.item_genres_that_can_be_used_in_games(game.id)

        @regist_item_trade_form = RegistItemTradeForm.new(game_id: game.id)
    end

    def create 
        @regist_item_trade_form = RegistItemTradeForm.new(regist_item_trade_form_params)

        if @regist_item_trade_form.save 
            redirect_to user_item_trades_path(id: @regist_item_trade_form.id, user_id: current_user.id), notice: t('flash.regist')
        else
            @selectable_item_genres = ItemGenreGame.item_genres_that_can_be_used_in_games(@regist_item_trade_form.game_id)
            render :new
        end
    end

    def edit 
        @item_trade = current_user.item_trades.find(params[:id])
        return redirect_to_permit_error if @item_trade.enable && @item_trade.item_trade_queue # 有効かつ、ユーザが購入中の場合は編集禁止
    end

    def update 
        @item_trade = current_user.item_trades.find(params[:id])
        return redirect_to_permit_error if @item_trade.enable && @item_trade.item_trade_queue # 有効かつ、ユーザが購入中の場合は編集禁止
        
        # 取引を再登録
        if @item_trade.update(update_item_trade_params)
            redirect_to user_item_trade_path(id: @item_trade.id, user_id: current_user.id), notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @item_trade = current_user.item_trades.find(params[:id])
        return redirect_to_permit_error if @item_trade.enable && @item_trade.item_trade_queue # 有効化つ、ユーザが購入中の場合は削除禁止

        if @item_trade.disable_trade
            redirect_to user_item_trades_path(user_id: current_user.id), notice: t('flash.destroy')
        else 
            redirect_to_error
        end
    end

    private
    
    def regist_item_trade_form_params 
        params.require(:regist_item_trade_form)
        .permit(:buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :numeric_of_trade_deadline, :buy_item_genre_id, :sale_item_genre_id)
        .merge(user_id: current_user.id, user_game_rank_id: UserGameRank.find_or_create_by(user_id: current_user.id, game_id: params[:game_id]).id, game_id: params[:game_id])
    end

    def update_item_trade_params 
        params.require(:item_trade).permit(:buy_item_quantity, :sale_item_quantity, :numeric_of_trade_deadline).merge(enable: true)
    end

    # 検索フォームのパラメータ（ソートも含む)
    def search_params
        params.require(:q).permit(:custom_buy_item_name_cont, :custom_buy_item_item_genre_id_eq, :custom_sale_item_name_cont, :custom_sale_item_item_genre_id_eq, :sorts)
    end
end
