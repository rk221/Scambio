class CreateNintendoFriendCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nintendo_friend_codes do |t|
      t.string :friend_code, null: false, limit: 12

      t.references :user, foreign_key: true, unique:true

      t.timestamps
    end
  end
end
