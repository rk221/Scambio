class Users::ItemTradeDetailsController < BaseUsersController
    def edit_buy # 取引登録者が評価
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue.item_trade) # ユーザID確認
        return redirect_to_error t('flash.item_trades.end_item_trade') if @item_trade_detail.buy_popuarity # 既に評価済みの場合エラー
    end

    def edit_sale # 取引購入者が評価
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue)    # ユーザID確認
        return redirect_to_error t('flash.item_trades.end_item_trade') if @item_trade_detail.sale_popuarity # 既に評価済みの場合エラー
    end


    def buy_evaluate # buy_popuarityを更新（取引登録者が評価）
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue.item_trade) # ユーザID確認
        return redirect_to_error t('flash.item_trades.end_item_trade') if @item_trade_detail.buy_popuarity # 既に評価済みの場合エラー
        
        if @item_trade_detail.buy_evaluate(buy_evaluate_params)
            redirect_to user_path(current_user), success: t('.success_message')
        else
            render :edit_buy
        end
    end

    def sale_evaluate# sale_popuarityを更新 (取引購入者が評価)
        @item_trade_detail = ItemTradeDetail.find(params[:id])
        return redirect_to_permit_error unless confirm_user(@item_trade_detail.item_trade_queue)    # ユーザID確認
        return redirect_to_error t('flash.item_trades.end_item_trade') if @item_trade_detail.sale_popuarity # 既に評価済みの場合エラー

        if @item_trade_detail.sale_evaluate(sale_evaluate_params)
            redirect_to user_path(current_user), success: t('.success_message')
        else
            render :edit_sale
        end
    end

    private

    def buy_evaluate_params
        params.require(:item_trade_detail).permit(:buy_popuarity)
    end

    def sale_evaluate_params
        params.require(:item_trade_detail).permit(:sale_popuarity)
    end
end
