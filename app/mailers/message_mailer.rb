class MessageMailer < ApplicationMailer
    def send_approve_item_trade(item_trade_queue)
        @item_trade_queue = item_trade_queue
        mail(
            subject: I18n.t('users.user_message_posts.shared.approve_item_trade.subject'),
            to: item_trade_queue.user.email
            )
    end

    def send_forced_item_trade(item_trade_queue)
        @item_trade_queue = item_trade_queue
        mail(
            subject: I18n.t('users.user_message_posts.shared.forced_item_trade.subject'),
            to: item_trade_queue.user.email
            )
    end

    def send_reject_item_trade(item_trade_queue)
        @item_trade_queue = item_trade_queue
        mail(
            subject: I18n.t('users.user_message_posts.shared.reject_item_trade.subject'),
            to: item_trade_queue.user.email
            )
    end

    def send_sell_item_trade(item_trade_queue)
        @item_trade_queue = item_trade_queue
        mail(
            subject: I18n.t('users.user_message_posts.shared.sell_item_trade.subject'),
            to: item_trade_queue.item_trade.user.email
            )
    end
end
