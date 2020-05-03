class ItemGenre < ApplicationRecord
    validates :name, presence: true, length: {maximum: 30}, uniqueness: true
    validates :default_unit_name, presence: true, length: {maximum: 10}
end
