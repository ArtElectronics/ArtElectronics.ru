# TODO Объединить эту миграцию с Users миграцией после завершения работы по нотификации логина. 

class AddConfirmableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email,    :string # Only if using reconfirmable
    
    ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable
  end
end
