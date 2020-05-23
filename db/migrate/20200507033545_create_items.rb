class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false, limit: 30
      t.string :unit_name, limit: 10

      t.references :item_genre, foreign_key: true, null: false
      t.references :game, foreign_key: true, null: false

      t.timestamps
    end
  end
end
