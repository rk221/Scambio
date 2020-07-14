class UserMessagePost < ApplicationRecord
    belongs_to :user

    validates :subject, presence: true, length: {maximum: 100}
    validates :message, presence: true
    validates :user_id, presence: true
    validates :already_read, inclusion: {in: [true, false]}

    def self.create_message_sell!(item_trade_queue)
        self.create!(user_id: item_trade_queue.item_trade.user_id, subject: I18n.t('users.user_message_posts.shared.sell_item_trade.subject'),message: message_template('sell_item_trade', item_trade_queue: item_trade_queue))
    end

    def self.create_message_reject!(item_trade_queue)
        self.create!(user_id: item_trade_queue.user_id, subject: I18n.t('users.user_message_posts.shared.reject_item_trade.subject'), message: message_template('reject_item_trade', item_trade_queue: item_trade_queue))
    end

    def self.create_message_approve!(item_trade_queue)
        self.create!(user_id: item_trade_queue.user_id, subject: I18n.t('users.user_message_posts.shared.approve_item_trade.subject'), message: message_template('approve_item_trade', item_trade_queue: item_trade_queue))
    end

    def self.create_message_forced!(item_trade_queue)
        self.create!(user_id: item_trade_queue.user_id, subject: I18n.t('users.user_message_posts.shared.forced_item_trade.subject'), message: message_template('forced_item_trade', item_trade_queue: item_trade_queue))
    end
    private

    def self.message_template(partial_name, locals)
        ApplicationController.renderer.render partial: "users/user_message_posts/shared/#{partial_name}", locals: locals 
    end
end
