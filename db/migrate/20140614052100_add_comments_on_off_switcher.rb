class AddCommentsOnOffSwitcher < ActiveRecord::Migration
  def change
    %w[ users posts pages ].each do |table|
      change_table table do |t|
        t.string :comments_switcher, default: :on
      end
    end
  end
end
