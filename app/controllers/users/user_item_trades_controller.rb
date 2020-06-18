class Users::UserItemTradesController < UsersController
    include ItemTrades

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
        @hash_pages = hash_pages((@item_trades.count() + NUMBER_OF_OUTPUT_LINES - 1) / NUMBER_OF_OUTPUT_LINES)
        # デコレータ　ページ(1 <= :page <=page_count) # includes enable
        @item_trades = ItemTradeDecorator.decorate_collection(@item_trades.limit(NUMBER_OF_OUTPUT_LINES).offset((page - 1) * NUMBER_OF_OUTPUT_LINES).includes(:enable_item_trade_queue))
        # ジャンル一覧を取得
        @selectable_item_genres = ItemGenre.all
    end

    def show 
        @item_trade = ItemTrade.find(params[:id]).decorate
        return redirect_to root_path, warning: t('flash.error') unless confirm_item_trade(@item_trade)
        @item_trade_queue = @item_trade.enable_item_trade_queue

        if @item_trade_queue.item_trade_detail
            @item_trade_chat = ItemTradeChat.new(item_trade_detail_id: @item_trade_queue.item_trade_detail.id, sender_is_seller: true) 
            @item_trade_chats = @item_trade_queue.item_trade_detail.item_trade_chats.order(created_at: :asc).decorate
        end
    end

    def respond # 購入応答 POST で 売却可否を受け取る
        @item_trade = ItemTrade.find(params[:id])
        @item_trade_queue = @item_trade.enable_item_trade_queue
        
        return redirect_to root_path, warning: t('flash.error') unless confirm_item_trade(@item_trade)

        if @item_trade_queue.update(respond_params)
            if @item_trade_queue.establish_flag # 成立→引き続き詳細画面 不成立→編集画面
                # Detailsを生成
                item_trade_detail = ItemTradeDetail.new(item_trade_queue_id: @item_trade_queue.id)
                item_trade_detail.save!
                
                redirect_to action: 'show', id: @item_trade.id, user_id: current_user.id, notice: t('.establish')
            else
                # 不成立メッセージを相手に送信（仮）
                # 取引を終了する。
                @item_trade.update!(enable_flag: false)
                @item_trade_queue.update!(enable_flag: false, lock_version: @item_trade_queue.lock_version)
                redirect_to edit_game_item_trade_path(id: @item_trade.id, game_id: @item_trade.game_id), notice: t('.not_establish')
            end
        else
            redirect_to root_path, warning: t('flash.error')
        end
    end

    private

    def item_trade_params 
        params.require(:item_trade).permit(:id, :user_id, :game_id, :buy_item_id, :buy_item_quantity, :sale_item_id, :sale_item_quantity, :enable_flag, :trade_deadline)
    end

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
