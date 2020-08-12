class UserBadge < ApplicationRecord
    belongs_to :user
    belongs_to :badge

    validates :user_id, presence: true, uniqueness: { scope: :badge_id }
    validates :badge_id, presence: true
    validates :wear, inclusion: {in: [true, false]}

    validate :with_select_up_to_3

    MAX_WEAR_BADGE = 3
    # 最大数以上の装着かどうかチェックする
    def with_select_up_to_3
        return true unless wear # バッジを装着しようとしているではない時は true
        self_id = id ? id : nil # idが存在しない（作成時はidにnilを格納する)
        if UserBadge.where(user_id: user_id, wear: true).where.not(id: self_id).size >= MAX_WEAR_BADGE # 既に装着しているバッジが最大以上
            errors.add(:base, UserBadge.human_attribute_name(:error_max_wear_badge))
        end
    end

    # ゲームIDに対応するユーザが付与可能なバッジを追加する
    def self.create_to_can_attach!(user_id, game_id)
        user_game_rank = UserGameRank.find_by(user_id: user_id)
        trade_count = user_game_rank.buy_trade_count + user_game_rank.sale_trade_count

        badges = Badge.where(game_id: game_id)
                .where('item_trade_count_condition <= ? AND rank_condition <= ?', trade_count, user_game_rank.rank)
                
        user_badges = UserBadge.where(user_id: user_id)
        badges = badges.where.not(id: user_badges.pluck(:badge_id)) unless user_badges.empty?
        badges.find_each do |badge|
            UserBadge.create!(user_id: user_id, badge_id: badge.id, wear: false)
        end
    end

    # ユーザのバッジ装着を行う（脱着も） 数と整数の入力値チェックはコントローラで行う
    def self.update_wear(user_badge_ids, user_id)
        user_badges = UserBadge.where(user_id: user_id)

        self.transaction do
            user_badges.where(wear: true).update_all(wear: false)   # ユーザのバッジ装着を外す

            user_badge_ids.each do |badge|                          # ユーザのバッジを装着していく
                user_badges.find(badge).update!(wear: true)
            end
        end
        true
    rescue
        false
    end
end
