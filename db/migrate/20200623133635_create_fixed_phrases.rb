class CreateFixedPhrases < ActiveRecord::Migration[6.0]
  def change
    create_table :fixed_phrases do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false, limit: 30
      t.text :text, null: false, limit: 100

      t.timestamps
    end
  end
end
