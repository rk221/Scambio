class ItemTradeQueue < ApplicationRecord
    belongs_to :user
    belongs_to :item_trade

    has_one :item_trade_detail, dependent: :nullify

    validates :item_trade_id, presence: true, uniqueness: true
    validates :user_id, presence: true
    validates :approve, inclusion: {in: [true, false]}

    # 購入中かつ未評価の取引一覧
    scope :trade_under_purchases, -> (current_user_id) do
        includes({item_trade: [:user, :game, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank]}, :item_trade_detail)
        .where(item_trade_queues: {user_id: current_user_id}, item_trades: {enable: true}, item_trade_details: {sale_popuarity: nil})
    end

    alias_method :save_old, :save
    # アイテムトレード購入処理
    def save
        item_trade = ItemTrade.find(item_trade_id)
        return false if item_trade.user_id == user_id # 購入者と売却者が一致しているとエラー
        
        self.approve = false # 承認はfalseに固定

        self.transaction do
            save!                                                                          # キューの生成(二重購入はユニーク制約で防ぐ)
            UserMessagePost.create_message_sell!(self)                                     # 成立メッセージを相手に送信
            UserGameRank.create(user_id: user_id, game_id: item_trade.game_id)             # ゲームランクを生成する user_idとgame_idで一意でなければvalidationで弾く。
        end
        true
    rescue
        false
    end

    # 購入者のゲームランクを取得する
    def user_game_rank(decorate: false)
        user_game_rank = user.user_game_ranks.find_by(game_id: self.item_trade.game_id)
        decorate ? user_game_rank.decorate : user_game_rank
    end
end
