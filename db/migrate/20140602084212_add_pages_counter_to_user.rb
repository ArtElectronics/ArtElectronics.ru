class AddPagesCounterToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :pages_count, default: 0
    end
  end
end
