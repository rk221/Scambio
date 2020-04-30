class User < ApplicationRecord
  has_one :nintendo_friend_code
  has_one :play_station_network_id

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



  def birthdate_cannot_be_in_the_future
    # 生年月日が入力済かつ未来日ではない
    if birthdate.present? && birthdate.future?
      errors.add(:birthdate, :birthdate_cannot_be_in_the_future)
    end
  end
  
end
