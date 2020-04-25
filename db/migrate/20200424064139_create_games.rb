class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :image_icon #画像データ
      t.timestamps
    end
  end
end
