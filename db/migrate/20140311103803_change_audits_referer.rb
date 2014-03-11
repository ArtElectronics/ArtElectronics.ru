class ChangeAuditsReferer < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :audits do |t|
        dir.up   { t.change :referer, :text }
        dir.down { t.change :referer, :string }
      end
    end
  end
end
