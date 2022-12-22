class AddSurfingbirdFlags < ActiveRecord::Migration
  def change
    [:posts, :blogs, :pages].each do |table_name|
      change_table table_name do |t|
        add_column table_name, :surfingbird, :boolean, default: false
      end
    end
  end
end
