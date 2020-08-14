class ItemTradeChat < ApplicationRecord
    mount_uploader :image, ChatImageUploader

    before_validation :delete_message_if_chat_is_image

    belongs_to :item_trade_detail

    validates :sender_is_seller, inclusion: {in: [true, false]}
    validates :item_trade_detail_id, presence: true
    validates :message, length: {maximum: 200}

    validate :object_not_empty

    # 画像の送信の場合にメッセージを消去する
    def delete_message_if_chat_is_image 
        self.message = "" if image.present?
    end

    def object_not_empty
        if image.blank? && message.blank?
            errors.add(:message, 'object_null')
        end
    end

    def template
        ApplicationController.renderer.render partial: 'users/item_trade_details/item_trade_chats/balloon', locals: { item_trade_chat: self.decorate }
    end
end
