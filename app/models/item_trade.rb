class ItemTrade < ApplicationRecord
    before_validation :set_trade_deadline
    attr_accessor :numeric_of_trade_deadline # 1~24の値を格納し、現時点から何時間有効なのか設定する

    belongs_to :user
    belongs_to :game
    belongs_to :user_game_rank

    belongs_to :buy_item, class_name: "Item", foreign_key: 'buy_item_id'
    belongs_to :sale_item, class_name: "Item", foreign_key: 'sale_item_id'

    has_one :item_trade_queue, dependent: :destroy
    has_one :item_trade_queue_user, through: :item_trade_queue, source: :user

    has_many :item_trade_details

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

    # 売却中の取引一覧（ユーザが存在する）
    scope :reaction_wait_item_trades, -> (current_user_id) do 
        includes(:game, {buy_item: :item_genre}, {sale_item: :item_genre}, :user_game_rank, {item_trade_queue: :item_trade_detail})
        .where(item_trades: {user_id: current_user_id, enable: true}, item_trade_details: {buy_popuarity: nil})
        .where.not(item_trade_queues: {id: nil})
    end

    # 取引が有効 かつ 期限が有効
    scope :enabled, -> {where("item_trades.enable = true and trade_deadline > ?", Time.zone.now)}
    # 取引が無効 か 期限が無効
    scope :disabled, -> {where("item_trades.enable = false or trade_deadline <= ?", Time.zone.now)}

    # 取引が有効か。取引中  #(ransack での検索ではオプション設定時、絶対に値を受け取らないといけない)
    scope :enabled_or_during_trade, -> (flag = true) do 
        if flag
            eager_load(:item_trade_queue)
            .where("item_trades.enable = true AND (item_trades.trade_deadline > ? OR item_trade_queues.id IS NOT NULL)", Time.zone.now)
        end
    end

    # 上記の結合を行なってから検索を行うこと！
    scope :custom_buy_item_name_cont, -> (search_name) do
        where(buy_item_id: Item.where('items.name like ?', "%" + search_name + "%").ids)
    end

    scope :custom_buy_item_item_genre_id_eq, -> (search_genre_id) do
        where(buy_item_id: Item.where(item_genre_id: search_genre_id).ids)
    end

    scope :custom_sale_item_name_cont, -> (search_name) do
        where(sale_item_id: Item.where('items.name like ?', "%" + search_name + "%").ids)
    end

    scope :custom_sale_item_item_genre_id_eq, -> (search_genre_id) do
        where(sale_item_id: Item.where(item_genre_id: search_genre_id).ids)
    end

    def self.ransackable_scopes(auth_object = nil)
        %i(enabled_or_during_trade custom_buy_item_name_cont custom_buy_item_item_genre_id_eq custom_sale_item_name_cont custom_sale_item_item_genre_id_eq)
    end

    # アイテムトレード正常終了処理
    def disable_trade
        self.transaction do
            update_attribute(:enable, false)   # before_validationは呼ばれないのでcolumnではなくattribute
            item_trade_queue&.destroy!    # queueが存在すればqueueを削除
        end
        true
    rescue
        false
    end

    # アイテムトレード強制終了処理
    def forced
        self.transaction do
            UserMessagePost.create_message_forced!(item_trade_queue)
            raise ActiveRecord::RecordInvalid unless disable_trade               # 取引を終了する。falseを返した場合、例外を返しこのトランザクションもロールバック
        end
        true
    rescue
        false
    end

    # 購入応答を処理する
    def respond(approve)
        return false if item_trade_queue.approve                                                            # 既に評価済みの場合エラー
        self.transaction do
            if approve
                item_trade_queue.update!(approve: true)                                                     # 応答処理
                UserMessagePost.create_message_approve!(item_trade_queue)                                   # 成立メッセージを相手に送信
                ItemTradeDetail.create!(item_trade_queue_id: item_trade_queue.id, item_trade_id: id)        # Detailsを生成
                raise ActiveRecord::RecordInvalid unless UserGameRank.update_trade_count(item_trade_queue)  # 取引回数をカウントアップ（両者）
            else
                UserMessagePost.create_message_reject!(item_trade_queue)                                    # 不成立メッセージを相手に送信
                item_trade_queue.destroy!                                                                   # キュー削除
                raise ActiveRecord::RecordInvalid unless disable_trade                                      # 取引を終了する。falseを返した場合、例外を返しこのトランザクションもロールバック
            end
        end
        true
        rescue
        false
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
