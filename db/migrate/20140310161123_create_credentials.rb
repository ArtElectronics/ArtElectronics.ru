class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.references :user
      
      t.string     :provider
      t.string     :uid

      t.text       :access_token
      t.text       :access_token_secret      
      t.string     :expires_at

      t.timestamps
    end
  end
end
