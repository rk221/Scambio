class ItemTradesController < ApplicationController
    NUMBER_OF_OUTPUT_LINES = 50
    def index #page paramsを受け取るとページ切り替え可能
        @q = ItemTrade.ransack(params[:q])
        @item_trades = ItemTradeDecorator.decorate_collection(@q.result(distinct: true).enabled.limit(NUMBER_OF_OUTPUT_LINES).offset(page * NUMBER_OF_OUTPUT_LINES))
    end

    def show 

    end

    def new 
        game = Game.find_by(id: params[:game_id])
        return redirect_to games_path, danger: t('flash.item_trades.game_does_not_exist') if game.nil?
        @selectable_item_genres = ItemGenreGame.where(game_id: game.id).joins(:item_genre).select(:item_genre_id, :name)
        @regist_item_trade_form = RegistItemTradeForm.new(game_id: game.id)
    end

    def create 
        @regist_item_trade_form = RegistItemTradeForm.new(regist_item_trade_form_params)
        @regist_item_trade_form.user_id = current_user.id
        if @regist_item_trade_form.save 
            redirect_to item_trades_path, notice: t('flash.regist')
        else
            @selectable_item_genres = ItemGenreGame.where(game_id: @regist_item_trade_form.game_id, enable_flag: true).joins(:item_genre).select(:item_genre_id, :name)
            render :new
        end
    end

    def edit 

    end

    def update 

    end

    def destroy

    end

    private
    def item_trade_params 
        params.require(:item_trade).permit(:id, :user_id, :game_id, :buy_item_id, :buy_item_quantity, :sale_item_id, :sale_item_quantity, :enable_flag, :trade_deadline)
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

    def page
        if /\A[0-9]+\z/.match?(params[:page])
            #整数の場合 数値変換し、返す
            return params[:page].to_i
        end
        #整数ではない又はnilの場合 0を返す
        return 0
    end
end
