class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.references :user
      t.string     :uid

      t.string     :provider
      t.string     :access_token
      t.string     :access_token_secret
      
      t.text       :full_credential

      t.timestamps
    end
  end
end
