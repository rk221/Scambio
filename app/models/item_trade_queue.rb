class ItemTradeQueue < ApplicationRecord
    belongs_to :user
    belongs_to :item_trade

    has_one :item_trade_detail, dependent: :destroy

    validates :item_trade_id, presence: true, uniqueness: true
    validates :user_id, presence: true
    validates :approve, inclusion: {in: [true, false]}

    # キューが購入されている状態
    scope :exist_user, -> {where.not(item_trade_queues: {user_id: nil})}
    # 売却中の取引一覧（ユーザが存在する）
    scope :reaction_wait_item_trade_queues, -> (current_user_id) do 
        includes({item_trade: [:game, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank]}, :item_trade_detail)
        .where(item_trades: {user_id: current_user_id, enable: true}, item_trade_details: {buy_popuarity: nil})
        .exist_user
    end
    # 購入中の取引一覧
    scope :trade_under_purchases, -> (current_user_id) do
        includes({item_trade: [:user, :game, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank]}, :item_trade_detail)
        .where(item_trade_queues: {user_id: current_user_id}, item_trades: {enable: true}, item_trade_details: {sale_popuarity: nil})
    end

    def buy(current_user_id)
        self.transaction do
            update!(user_id: current_user_id)
            # 成立メッセージを相手に送信
            UserMessagePost.create_message_sell!(self)
            # ゲームランクを生成する user_idとgame_idで一意でなければvalidationで弾く。
            UserGameRank.create(user_id: current_user_id, game_id: self.item_trade.game_id)
        end
        true
    rescue
        false
    end

    # アイテムトレードに対応する購入待機用枠を作成する
    def self.create_enabled!(item_trade_id)
        # 既に、登録済みで、有効な購入待ちが存在する場合
        self.create!(item_trade_id: item_trade_id, user_id: nil, approve: nil)
    end
end
