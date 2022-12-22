class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string  :email,  default: ""
      t.string  :state,  default: :unactive
      t.boolean :user_send_state, default: true
      t.string  :confirmation_token

      t.timestamps
    end

    add_index :subscribers, :email, unique: true
  end
end
