class AddBotFlagToAudits < ActiveRecord::Migration
  def change
    change_table :audits do |t|
      t.boolean :bot, default: false
    end
  end
end
