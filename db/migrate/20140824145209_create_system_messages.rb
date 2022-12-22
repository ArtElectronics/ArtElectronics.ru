class CreateSystemMessages < ActiveRecord::Migration
  def change
    create_table :system_messages do |t|
      t.integer :user_id
      t.string :message_type
      t.text :message

      t.timestamps
    end
  end
end
