class User < ApplicationRecord
  has_one :nintendo_friend_code, dependent: :destroy
  has_one :play_station_network_id, dependent: :destroy
  has_many :fixed_phrases, dependent: :destroy

  has_many :user_message_posts, dependent: :destroy
  
  has_many :user_game_ranks
  has_many :user_game_rank_games, through: :user_game_ranks, source: :game

  has_many :item_trades
  has_many :item_trade_games, through: :item_trades, source: :game
  has_many :buy_items, through: :item_trades, source: :buy_item
  has_many :sale_items, through: :item_trades, source: :sale_item

  has_many :buy_item_trade_detials, class_name: "ItemTradeDetial", foreign_key: "buy_user_id"
  has_many :buy_item_trades, through: :buy_item_trade_detials

  has_many :item_trade_queues
  has_many :item_trade_queue_item_trades, through: :item_trade_queues, source: :item_trade

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  # 名前は全角平仮名、漢字（鬼車）のみ許可
  VALID_NAME_REGEX = /\A(?:\p{Hiragana}|[ー－]|[一-龠々])+\z/
  validates :firstname, presence: true, format: {with: VALID_NAME_REGEX}
  validates :lastname, presence: true, format: {with: VALID_NAME_REGEX}
  validates :nickname, presence: true, length: {in: 4..30}
  validates :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future
  validates :admin, inclusion: {in: [true, false]}


  def birthdate_cannot_be_in_the_future
    # 生年月日が入力済かつ未来日ではない
    if birthdate.present? && birthdate.future?
      errors.add(:birthdate, I18n.t('errors.messages.birthdate_cannot_be_in_the_future'))
    end
  end
  
end
