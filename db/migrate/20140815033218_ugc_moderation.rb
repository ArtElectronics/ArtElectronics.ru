class UgcModeration < ActiveRecord::Migration
  def change
    %w[ blogs posts pages hubs ].each do |tname|
      remove_column tname, :moderation_state
      remove_column tname, :moderator_note
    end

    [:posts, :blogs, :pages].each do |table_name|
      change_table table_name do |t|
        # unmoderated, moderated
        add_column table_name, :moderation_state, :string, default: :unmoderated
        add_column table_name, :moderator_note,   :text
        add_column table_name, :moderated_at,     :timestamp

        puts "~~~> #{ table_name } should be defined as :moderated".upcase
      end
    end
  end
end
