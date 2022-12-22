class AddNovotekaFlags < ActiveRecord::Migration
  def change
    [:posts, :blogs, :pages].each do |table_name|
      change_table table_name do |t|
        add_column table_name, :novoteka, :boolean, default: false
      end
    end
  end
end
