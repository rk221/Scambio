class ItemTrade < ApplicationRecord
    before_validation :set_trade_deadline
    attr_accessor :numeric_of_trade_deadline # 1~24の値を格納し、現時点から何時間有効なのか設定する

    belongs_to :user
    belongs_to :game

    belongs_to :buy_item, class_name: "Item", foreign_key: 'buy_item_id'
    belongs_to :sale_item, class_name: "Item", foreign_key: 'sale_item_id'

    has_many :item_trade_queues, dependent: :destroy
    has_many :item_trade_queue_users, through: :item_trade_queues, source: :user

    belongs_to :enable_item_trade_queue, class_name: "ItemTradeQueue", foreign_key: "enable_item_trade_queue_id", optional: true

    belongs_to :user_game_rank

    validates :buy_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :sale_item_quantity, presence: true, numericality: {greater_than_or_equal_to: 1}
    validates :user_id, presence: true
    validates :game_id, presence: true
    validates :buy_item_id, presence: true
    validates :sale_item_id, presence: true
    validates :enable, inclusion: {in: [true, false]}
    validates :trade_deadline, presence: true
    validates :numeric_of_trade_deadline, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 24}
    validates :user_game_rank_id, presence: true

    # 取引が有効 かつ 期限が有効
    scope :enabled, -> {where("item_trades.enable = true and trade_deadline > ?", Time.zone.now)}
    # 取引が無効 か 期限が無効
    scope :disabled, -> {where("item_trades.enable = false or trade_deadline <= ?", Time.zone.now)}

    # 取引が有効な時
    scope :enabled_or_during_trade, -> do 
        eager_load(:item_trade_queues)
        .where("item_trades.enable = true AND (item_trades.trade_deadline > ? OR item_trade_queues.user_id IS NOT NULL)", Time.zone.now)
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
        self.transaction do
            update!(buy_item_quantity: update_params[:buy_item_quantity], sale_item_quantity: update_params[:sale_item_quantity], enable: true, numeric_of_trade_deadline: update_params[:numeric_of_trade_deadline])
            set_enable_item_trade_queue!
        end 
        true
        rescue
        false
    end

    # アイテムトレード正常終了処理
    def disable_trade!
        update_attribute(:enable, false)   # before_validationは呼ばれないのでcolumnではなくattribute
    end

    def forced
        self.transaction do
            UserMessagePost.create_message_forced!(self.enable_item_trade_queue.decorate)
            disable_trade!
        end
        true
    rescue
        false
    end

    # 購入応答を処理する
    def respond(respond_params)
        self.transaction do
            raise ActiveRecord::RecordInvalid if enable_item_trade_queue.establish                                       # 既に評価済みの場合エラー

            enable_item_trade_queue.update!(respond_params)
            if enable_item_trade_queue.establish
                UserMessagePost.create_message_approve!(enable_item_trade_queue)            # 成立メッセージを相手に送信
                ItemTradeDetail.create!(item_trade_queue_id: enable_item_trade_queue.id)    # Detailsを生成
            else
                UserMessagePost.create_message_reject!(enable_item_trade_queue.decorate)    # 不成立メッセージを相手に送信
                raise ActiveRecord::RecordInvalid unless disable_trade!                      # 取引を終了する。falseを返した場合、例外を返しこのトランザクションもロールバック
            end
        end
        true
        rescue
        false
    end

    # アイテムトレードに、有効なキューを格納する 例外を投げ、呼び出し元で補足する
    def set_enable_item_trade_queue! 
        item_trade_queue = ItemTradeQueue.create_enabled!(self.id)
        update!(enable_item_trade_queue_id: item_trade_queue.id)
    end

    private
    def set_trade_deadline 
        self.trade_deadline = calc_trade_deadline(@numeric_of_trade_deadline)
    end
    # 日付を1~24の値からTimeWithZoneに変換する 数値が入っていない場合nilを返す
    def calc_trade_deadline(numeric_of_trade_deadline)
        numeric_of_trade_deadline.blank? ? nil : numeric_of_trade_deadline.to_i.hours.since
    end
end
