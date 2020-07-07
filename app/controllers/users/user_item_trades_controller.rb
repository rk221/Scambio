class Users::UserItemTradesController < UsersController
    helper_method :page_redirect_params    
    before_action :user_auth

    NUMBER_OF_OUTPUT_LINES = 10

    # ユーザの取引一覧
    def index #page paramsを受け取るとページ切り替え可能
        # 検索
        params[:q] = {sorts: 'updated_at desc'} if params[:q].blank?
        @q = ItemTrade.ransack(search_params)
        @item_trades = search_item_trades(@q.result(distinct: true), search_params).where(user_id: current_user.id) # ユーザの物だけ抽出する
        # ページリンク用オブジェクト
        @hash_pages = hash_pages((@item_trades.size + NUMBER_OF_OUTPUT_LINES - 1) / NUMBER_OF_OUTPUT_LINES)
        # デコレータ　ページ(1 <= :page <=page_count) # includes enable
        @item_trades = @item_trades.limit(NUMBER_OF_OUTPUT_LINES).offset((page - 1) * NUMBER_OF_OUTPUT_LINES).includes(:enable_item_trade_queue, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank, :game).decorate
        # ジャンル一覧を取得
        @selectable_item_genres = ItemGenre.all
    end

    def show 
        @item_trade_queue = current_user.item_trades.find(params[:id]).enable_item_trade_queue.decorate
        redirect_to_error t('flash.item_trades.end_item_trade') unless @item_trade_queue.enable_flag

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id) 
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end

        @user = current_user.decorate
    end

    def respond # 購入応答 POST で 売却可否を受け取る
        @item_trade = current_user.item_trades.find(params[:id])
        
        if @item_trade.respond(respond_params)
            if @item_trade.enable_item_trade_queue.establish_flag # 成立→引き続き詳細画面 不成立→編集画面
                redirect_to action: 'show', id: @item_trade.id, user_id: current_user.id, notice: t('.establish')
            else
                redirect_to edit_game_item_trade_path(id: @item_trade.id, game_id: @item_trade.game_id), notice: t('.not_establish')
            end
        else
            redirect_to_error 
        end
    end

    private

    def respond_params
        params.require(:item_trade_queue).permit(:id, :establish_flag, :lock_version)
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
        params.require(:q).permit(:enabled_or_during_trade, :game_title_cont, :buy_item_name, :sale_item_name, :buy_item_item_genre_id, :sale_item_item_genre_id, :sorts)
    end
    # ページを変更する時のパラメータ（ヘルパー）
    def page_redirect_params(page)
        {page: page, q: search_params}
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
