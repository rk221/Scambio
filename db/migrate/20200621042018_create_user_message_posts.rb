class CreateUserMessagePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_message_posts do |t|
      t.references :user, foreign_key: true, null: false
      t.string :subject, null: false, limit: 100
      t.text :message, null: false
      t.boolean :already_read, default: false, null: false

      t.timestamps
    end
  end
end
