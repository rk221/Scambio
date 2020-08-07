class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :name, null: false, limit: 30

      t.integer :item_trade_count_condition, null: false, default: 0
      t.integer :rank_condition, null: false, default: 0

      t.references :game, foreign_key: true, null: false

      t.timestamps
    end

    add_index :badges, :name, unique: true
  end
end
