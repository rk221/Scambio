class ItemTradeDetailsController < ApplicationController
    include Errors 
    include Users

    def edit_buy # 取引登録者が評価
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        # ユーザID確認
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue.item_trade)
    end

    def edit_sale # 取引購入者が評価
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        # ユーザID確認
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue)
    end


    def buy_evaluate # buy_popuarityを更新（取引登録者が評価）
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        # ユーザID確認
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue.item_trade)
        
        if @item_trade_detail.update(buy_evaluate_params)
            end_trade(@item_trade_detail) if @item_trade_detail.sale_popuarity # 両者評価しているなら取引を終了させる

            # 購入側のRANKを更新
            buy_user_game_rank = UserGameRank.find_by(user_id: @item_trade_detail.item_trade_queue.user_id, game_id: @item_trade_detail.item_trade_queue.item_trade.game_id)
            buy_user_game_rank.buy_item_trade_update!(@item_trade_detail.buy_popuarity)

            redirect_to user_path(current_user), success: t('.success_message')
        else
            render :edit_buy
        end
    end

    def sale_evaluate# sale_popuarityを更新 (取引購入者が評価)
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        # ユーザID確認
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue)

        if @item_trade_detail.update(sale_evaluate_params)
            end_trade(@item_trade_detail) if @item_trade_detail.buy_popuarity # 両者評価しているなら取引を終了させる

            # 購入側のRANKを更新
            sale_user_game_rank = UserGameRank.find_by(user_id: @item_trade_detail.item_trade_queue.item_trade.user_id, game_id: @item_trade_detail.item_trade_queue.item_trade.game_id)
            sale_user_game_rank.sale_item_trade_update!(@item_trade_detail.sale_popuarity)

            redirect_to user_path(current_user), success: t('.success_message')
        else
            render :edit_sale
        end
    end

    private

    def end_trade(item_trade_detail) # 取引を終了する
        item_trade_detail.item_trade_queue.update!(enable_flag: false)
        item_trade_detail.item_trade_queue.item_trade.update!(enable_flag: false)
    end

    def buy_evaluate_params
        params.require(:item_trade_detail).permit(:buy_popuarity)
    end

    def sale_evaluate_params
        params.require(:item_trade_detail).permit(:sale_popuarity)
    end
end
