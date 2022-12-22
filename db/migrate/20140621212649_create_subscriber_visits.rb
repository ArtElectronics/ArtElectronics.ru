class CreateSubscriberVisits < ActiveRecord::Migration
  def change
    create_table :subscriber_visits do |t|
      t.string :email, default: ''
      t.text   :path

      t.timestamps
    end
  end
end
