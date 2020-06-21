class CreateUserMessagePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_message_posts do |t|
      t.references :user, foreign_key: true, null: false
      t.text :message, null: false
      t.boolean :already_read_flag, default: false, null: false

      t.timestamps
    end
  end
end
