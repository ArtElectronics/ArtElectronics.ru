class UgcFlag < ActiveRecord::Migration
  def change
    [:posts, :blogs, :pages].each do |table_name|
      change_table table_name do |t|
        t.boolean :ugc, default: false
      end
    end
  end
end
