class UserGameRank < ApplicationRecord
    belongs_to :user
    belongs_to :game
    has_many :item_trades

    validates :user_id, presence: true, uniqueness: {scope: :game_id}
    validates :game_id, presence: true

    validates :rank, presence: true, numericality: {greater_than_or_equal_to: -2, less_than_or_equal_to: 4}
    validates :buy_trade_count, presence: true, numericality: {greater_than_or_equal_to: 0}
    validates :sale_trade_count, presence: true, numericality: {greater_than_or_equal_to: 0}
    validates :popularity, presence: true, numericality: {greater_than_or_equal_to: -100, less_than_or_equal_to: 100}

    after_update :update_rank

    def buy_item_trade_update!(add_popularity)
        update!(popularity: self.popularity + add_popularity)
    end

    def sale_item_trade_update!(add_popularity)
        update!(popularity: self.popularity + add_popularity)
    end

    def self.update_trade_count!(item_trade_queue)
        sale_user_game_rank = UserGameRank.find_by(user_id: item_trade_queue.item_trade.user_id, game_id: item_trade_queue.item_trade.game_id) 
        buy_user_game_rank = UserGameRank.find_by(user_id: item_trade_queue.user_id, game_id: item_trade_queue.item_trade.game_id) 
        sale_user_game_rank.update!(sale_trade_count: sale_user_game_rank.sale_trade_count + 1)# 売却者の取引回数カウントアップ
        buy_user_game_rank.update!(buy_trade_count: buy_user_game_rank.buy_trade_count + 1)# 購入者の取引回数カウントアップ
    end
    
    private 

    def update_rank # 更新時、ランクを更新する
        return if self.buy_trade_count + self.sale_trade_count < 10 # 取引が１０回未満なのでグレー
        if self.popularity <= -40 # レッド
            rank = -2
        elsif self.popularity <= -20 # オレンジ
            rank = -1
        elsif self.popularity <= 10 # ホワイト
            rank = 1
        elsif self.popularity <= 40 # グリーン
            rank = 2
        elsif self.popularity <= 70 # ゴールド
            rank = 3
        else # ダイヤ
            rank = 4
        end
        
        self.update_column(:rank, rank)
    end
end
