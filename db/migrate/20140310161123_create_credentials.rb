class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.references :user
      t.string     :provider
      t.string     :token
      t.text       :credential

      t.timestamps
    end
  end
end
