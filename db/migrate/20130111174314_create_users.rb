class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :username
      
      # the_role
      t.integer :role_id,    default: nil
      t.integer :show_count, default: 0
      t.string  :state,      default: :active # active | banned

      # cache_counters => published
      t.integer :hubs_count,  default: 0
      t.integer :posts_count, default: 0

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end