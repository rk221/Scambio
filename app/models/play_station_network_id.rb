class PlayStationNetworkId < ApplicationRecord
    belongs_to :user

    # PSN_IDは英数字、ハイフン、アンダーバーのみ許可
    VALID_PSN_ID_REGEX = /\A[0-9A-Za-z\-_]+\z/

    validates :psn_id, presence: true, length: {in: 3..16}, format: {with: VALID_PSN_ID_REGEX}
    validates :user_id, presence: true, uniqueness: true

    validate :psn_id_head_alphabet

    def psn_id_head_alphabet 
        # PSN＿IDの先頭文字がアルファベットかどうかチェック
        unless /^[A-Za-z]/ === psn_id
            errors.add(:psn_id, :psn_id_head_alphabet)
        end
    end
end
