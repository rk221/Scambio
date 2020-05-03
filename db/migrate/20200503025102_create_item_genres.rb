class CreateItemGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :item_genres do |t|
      t.string :name, null: false, limit: 30
      t.string :default_unit_name, null: false, limit: 10

      t.timestamps
    end

    add_index :item_genres, :name, unique: true
  end
end
