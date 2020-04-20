class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 名前は全角平仮名、全角カタカナ、漢字（鬼車）のみ許可
  VALID_NAME_REGEX = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  validates :firstname, presence: true, format: {with: VALID_NAME_REGEX}
  validates :lastname, presence: true, format: {with: VALID_NAME_REGEX}
  validates :nickname, presence: true, length: {in: 4..30}
end
