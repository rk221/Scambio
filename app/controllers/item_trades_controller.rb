class ItemTradesController < ApplicationController
    helper_method :page_redirect_params    

    NUMBER_OF_OUTPUT_LINES = 10

    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        @item_trades = search_item_trades(@q.result(distinct: true), search_params).enabled
        # ページリンク用オブジェクト
        @hash_pages = hash_pages((@item_trades.count() + NUMBER_OF_OUTPUT_LINES - 1) / NUMBER_OF_OUTPUT_LINES)
        # デコレータ　ページ(1 <= :page <=page_count)
        @item_trades = ItemTradeDecorator.decorate_collection(@item_trades.limit(NUMBER_OF_OUTPUT_LINES).offset((page - 1) * NUMBER_OF_OUTPUT_LINES))
        # ジャンル一覧を取得
        @selectable_item_genres = selectable_item_genres(params[:game_id])
    end

    def show 

    end

    def new 
        game = Game.find_by(id: params[:game_id])
        return redirect_to games_path, danger: t('flash.item_trades.game_does_not_exist') if game.nil?
        @selectable_item_genres = selectable_item_genres(game.id)
        @regist_item_trade_form = RegistItemTradeForm.new(game_id: game.id)
    end

    def create 
        @regist_item_trade_form = RegistItemTradeForm.new(regist_item_trade_form_params)
        @regist_item_trade_form.user_id = current_user.id
        if @regist_item_trade_form.save 
            # ゲームランクを生成する
            user_game_rank = UserGameRank.new(user_id: current_user.id, game_id: @regist_item_trade_form.game_id)
            user_game_rank.save

            redirect_to game_item_trades_path(game_id: @regist_item_trade_form.game_id), notice: t('flash.regist')
        else
            @selectable_item_genres = ItemGenreGame.where(game_id: @regist_item_trade_form.game_id, enable_flag: true).joins(:item_genre).select(:item_genre_id, :name)
            @selectable_item_genres = selectable_item_genres(@regist_item_trade_form.game_id)
            render :new
        end
    end

    def edit 
        @item_trade = ItemTrade.find(params[:id])
    end

    def update 
        @item_trade = ItemTrade.find(params[:id])
        
        if @item_trade.update(buy_item_quantity: item_trade_params[:buy_item_quantity], sale_item_quantity: item_trade_params[:sale_item_quantity], trade_deadline: calc_trade_deadline(item_trade_params[:trade_deadline]))
            redirect_to game_item_trades_path(game_id: @item_trade.game_id), notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @item_trade = ItemTrade.find(params[:id])
        @item_trade.update(enable_flag: false)
        redirect_to game_item_trades_path(game_id: params[:game_id]), notice: t('flash.destroy')
    end

    private
    def item_trade_params 
        params.require(:item_trade).permit(:id, :user_id, :game_id, :buy_item_id, :buy_item_quantity, :sale_item_id, :sale_item_quantity, :enable_flag, :trade_deadline)
    end

    def calc_trade_deadline(trade_deadline)
        if trade_deadline.present?
            return trade_deadline.to_i.hours.since
        else
            return nil
        end
    end

    def regist_item_trade_form_params 
        params.require(:regist_item_trade_form).permit(:game_id, :buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :enable_flag, :trade_deadline, :buy_item_genre_id, :sale_item_genre_id)
    end

    

    def buy_item_params 
        params.require(:item_trade).permit(:buy_item_name, :game_id, :buy_item_genre_id)
    end

    def sale_item_params 
        params.require(:item_trade).permit(:sale_item_name, :game_id, :sale_item_genre_id)
    end

    def game_name_params
        params.require(:item_trade).permit(:game_name)
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

    def search_item_trades (item_trades, search_params) #　自作の検索を行う
        item_trades = item_trades.left_join_buy_item.left_join_sale_item
        item_trades = item_trades.search_buy_item_name(search_params[:buy_item_name]) if search_params[:buy_item_name].present?
        item_trades = item_trades.search_sale_item_name(search_params[:sale_item_name]) if search_params[:sale_item_name].present?
        item_trades = item_trades.search_buy_item_genre_id(search_params[:buy_item_item_genre_id]) if search_params[:buy_item_item_genre_id].present?
        item_trades = item_trades.search_sale_item_genre_id(search_params[:sale_item_item_genre_id]) if search_params[:sale_item_item_genre_id].present?
        return item_trades
    end

    def selectable_item_genres(game_id = nil)
        ItemGenreGame.enabled.where(game_id: game_id).joins(:item_genre).select(:item_genre_id, :name)
    end
end
