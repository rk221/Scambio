class ItemTrade < ApplicationRecord
    before_validation :set_trade_deadline
    attr_accessor :numeric_of_trade_deadline

    belongs_to :user
    belongs_to :game

    belongs_to :buy_item, class_name: "Item", foreign_key: 'buy_item_id'
    belongs_to :sale_item, class_name: "Item", foreign_key: 'sale_item_id'

    has_many :item_trade_queues
    has_many :item_trade_queue_users, through: :item_trade_queues, source: :user

    belongs_to :enable_item_trade_queue, class_name: "ItemTradeQueue", foreign_key: "enable_item_trade_queue_id", optional: true

    belongs_to :user_game_rank

    validates :buy_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :sale_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :user_id, presence: true
    validates :game_id, presence: true
    validates :buy_item_id, presence: true
    validates :sale_item_id, presence: true
    validates :enable_flag, inclusion: {in: [true, false]}
    validates :trade_deadline, presence: true
    validates :numeric_of_trade_deadline, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 24}
    validates :user_game_rank_id, presence: true

    # 取引が有効 かつ 期限が有効
    scope :enabled, -> {where("item_trades.enable_flag = true and trade_deadline > ?", Time.zone.now)}
    # 取引が無効 か 期限が無効
    scope :disabled, -> {where("item_trades.enable_flag = false or trade_deadline <= ?", Time.zone.now)}

    # 取引が有効な時
    scope :enabled_or_during_trade, -> do 
        eager_load(:item_trade_queues)
        .where("item_trades.enable_flag = true AND (item_trades.trade_deadline > ? OR item_trade_queues.user_id IS NOT NULL)", Time.zone.now)
    end

    # 上記の結合を行なってから検索を行うこと！
    scope :search_buy_item_name, -> (search_name){
        where(buy_item_id: Item.where('items.name like ?', "%" + search_name + "%").ids)
    }
    scope :search_buy_item_genre_id, -> (search_genre_id){
        where(buy_item_id: Item.where(item_genre_id: search_genre_id).ids)
    }
    scope :search_sale_item_name, -> (search_name){
        where(sale_item_id: Item.where('items.name like ?', "%" + search_name + "%").ids)
    }
    scope :search_sale_item_genre_id, -> (search_genre_id){
        where(sale_item_id: Item.where(item_genre_id: search_genre_id).ids)
    }

    def self.ransackable_scopes(auth_object = nil)
        %i(enabled_or_during_trade)
    end

    # アイテムトレードを、数量と期限のみ編集し直し、再登録する(後々取引自体のカウントが追加され信用が上がる)
    def re_regist(update_params)
        ItemTrade.transaction do
            update!(buy_item_quantity: update_params[:buy_item_quantity], sale_item_quantity: update_params[:sale_item_quantity], enable_flag: true, numeric_of_trade_deadline: update_params[:numeric_of_trade_deadline])
            set_enable_item_trade_queue!
        end 
        true
        rescue => e
        false
    end

    # アイテムトレード正常終了処理
    def disable_trade
        self.transaction do # 両方更新が完了できれば正常
            update_attribute(:enable_flag, false) # before_validationは呼ばれないのでcolumnではなくattribute
            enable_item_trade_queue.update!(enable_flag: false)
        end
        true
        rescue => e
        false
    end

    # アイテムトレードに、有効なキューを格納する
    def set_enable_item_trade_queue! 
        item_trade_queue = ItemTradeQueue.create_enabled!(self.id)
        update!(enable_item_trade_queue_id: item_trade_queue.id)
    end

    private
    def set_trade_deadline
        self.trade_deadline = calc_trade_deadline(@numeric_of_trade_deadline)
    end

    def calc_trade_deadline(numeric_of_trade_deadline)# 空文字列の時もnilを返す
        numeric_of_trade_deadline.blank? ? nil : numeric_of_trade_deadline.to_i.hours.since
    end
end
