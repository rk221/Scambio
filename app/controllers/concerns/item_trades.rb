module ItemTrades
    extend ActiveSupport::Concern

    def confirm_item_trade(item_trade)
        if item_trade.user_id == current_user.id
            return true
        else
            return false
        end
    end
end