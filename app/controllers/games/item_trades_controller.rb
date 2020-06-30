class Games::ItemTradesController < ApplicationController
    include Users

    helper_method :page_redirect_params    

    NUMBER_OF_OUTPUT_LINES = 10

    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        # 検索に会うもの + 有効な取引 + 購入されていない取引 + ゲームに一致している
        @item_trades = search_item_trades(@q.result(distinct: true), search_params).enabled.includes(:enable_item_trade_queue).joins(:game).where(item_trade_queues: {user_id: nil, enable_flag: true}, game_id: params[:game_id])
        # ページリンク用オブジェクト
        @hash_pages = hash_pages((@item_trades.count() + NUMBER_OF_OUTPUT_LINES - 1) / NUMBER_OF_OUTPUT_LINES)
        # デコレータ　ページ(1 <= :page <=page_count)
        @item_trades = @item_trades.limit(NUMBER_OF_OUTPUT_LINES).offset((page - 1) * NUMBER_OF_OUTPUT_LINES).includes(:user, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank).decorate
        # ジャンル一覧を取得
        @selectable_item_genres = ItemGenreGame.selectable_item_genres(params[:game_id])
    end

    def new 
        game = Game.find_by(id: params[:game_id])
        return redirect_to games_path, danger: t('flash.item_trades.game_does_not_exist') if game.nil?
        @selectable_item_genres = ItemGenreGame.selectable_item_genres(game.id)

        # ゲームランクが存在しなければを生成する 
        user_game_rank = UserGameRank.find_or_create_by(user_id: current_user.id, game_id: game.id)

        @regist_item_trade_form = RegistItemTradeForm.new(game_id: game.id, user_game_rank_id: user_game_rank.id)
    end

    def create 
        @regist_item_trade_form = RegistItemTradeForm.new(regist_item_trade_form_params)

        if @regist_item_trade_form.save 
            # アイテムトレードに、有効なキューを格納する
            ItemTrade.find(@regist_item_trade_form.id).update!(enable_item_trade_queue_id: ItemTradeQueue.create_enabled(@regist_item_trade_form.id).id)

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
        
        if @item_trade.update(update_item_trade_params)
            # アイテムトレードに、有効なキューを格納する
            @item_trade.update!(enable_item_trade_queue_id: ItemTradeQueue.create_enabled(@item_trade.id).id)
            
            redirect_to user_user_item_trade_path(id: @item_trade.id, user_id: current_user.id), notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @item_trade = current_user.item_trades.find(params[:id])

        @item_trade.update!(enable_flag: false)
        redirect_to user_user_item_trades_path(user_id: current_user.id), notice: t('flash.destroy')
    end

    private
    def update_item_trade_params 
        p = params.require(:item_trade).permit(:buy_item_quantity, :sale_item_quantity).merge(enable_flag: true, trade_deadline: calc_trade_deadline(params[:item_trade][:trade_deadline]))
    end

    def calc_trade_deadline(trade_deadline)
        return nil if trade_deadline.blank?
        return trade_deadline.to_i.hours.since
    end

    def regist_item_trade_form_params 
        params.require(:regist_item_trade_form).permit(:game_id, :buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :trade_deadline, :buy_item_genre_id, :sale_item_genre_id, :user_game_rank_id).merge(user_id: current_user.id)
    end

    # ページを変更する際の << < 1 2 3 4 5 > >> を表示するために、リンクとページ数を保持するためのもの valueがfalseの場合はリンクとして使用しない。順序は大事なので注意
    def hash_pages(page_count)
        current_page = page()
        object = {}

        if page_count > 1
            if current_page > 1 # 1ページではない場合にバックのリンクを追加する
                object.store("<<", 1) 
                object.store("<",current_page - 1) 
            end
            
            (1..3).reverse_each do |i|
                object.store("#{current_page - i}", current_page - i) if current_page - i >= 1
            end
            
            object.store("#{current_page}", false)

            (1..3).each do |i|
                object.store("#{current_page + i}", current_page + i) if current_page + i <= page_count
            end

            if current_page < page_count # 最終ページではない場合にネクストのリンクを追加する
                object.store(">", current_page + 1)
                object.store(">>", page_count) 
            end
        else
            object.store("1", false)
        end
        object
    end

    def page
        if /\A[0-9]+\z/.match?(params[:page])
            #整数の場合 数値変換し、返す
            return params[:page].to_i
        end
        #整数ではない又はnilの場合 1を返す
        return 1
    end

    # 検索フォームのパラメータ（ソートも含む)
    def search_params
        params.require(:q).permit(:buy_item_name, :sale_item_name, :buy_item_item_genre_id, :sale_item_item_genre_id, :sorts)
    end
    # ページを変更する時のパラメータ（ヘルパー）
    def page_redirect_params(page)
        {page: page, q: search_params}
    end
    #　自作の検索を行う
    def search_item_trades (item_trades, search_params) 
        item_trades = item_trades.left_join_buy_item.left_join_sale_item
        item_trades = item_trades.search_buy_item_name(search_params[:buy_item_name]) if search_params[:buy_item_name].present?
        item_trades = item_trades.search_sale_item_name(search_params[:sale_item_name]) if search_params[:sale_item_name].present?
        item_trades = item_trades.search_buy_item_genre_id(search_params[:buy_item_item_genre_id]) if search_params[:buy_item_item_genre_id].present?
        item_trades = item_trades.search_sale_item_genre_id(search_params[:sale_item_item_genre_id]) if search_params[:sale_item_item_genre_id].present?
        return item_trades
    end
end
