class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :username, default: ''
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      # the_role
      t.integer :role_id,    default: nil
      t.integer :show_count, default: 0
      t.string  :state,      default: :active # active | banned

      # cache_counters => published
      t.integer :hubs_count,  default: 0
      t.integer :posts_count, default: 0

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true

    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end