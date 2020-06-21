class UserMessagePost < ApplicationRecord
    belongs_to :user

    validates :message, presence: true
    validates :user_id, presence: true
    validates :already_read_flag, inclution: {in: [:true, :false]}
end
