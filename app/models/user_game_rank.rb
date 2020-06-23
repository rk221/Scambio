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
        self.update!(popularity: popularity + add_popularity, buy_trade_count: buy_trade_count + 1)
    end

    def sale_item_trade_update!(add_popularity)
        self.update!(popularity: popularity + add_popularity, sale_trade_count: sale_trade_count + 1)
    end
    
    private 

    def update_rank # 更新時、ランクを更新する
        return if buy_trade_count + sale_trade_count < 10 # 取引が１０回未満なのでグレー
        if popularity <= -40 # レッド
            rank = -2
        elsif popularity <= -20 # オレンジ
            rank = -1
        elsif popularity <= 10 # ホワイト
            rank = 1
        elsif popularity <= 40 # グリーン
            rank = 2
        elsif popularity <= 70 # ゴールド
            rank = 3
        else # ダイヤ
            rank = 4
        end
        
        self.update_column(:rank, rank)
    end
end
