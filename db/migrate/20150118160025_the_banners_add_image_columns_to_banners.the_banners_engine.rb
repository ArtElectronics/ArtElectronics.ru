# This migration comes from the_banners_engine (originally 20141216230350)
class TheBannersAddImageColumnsToBanners < ActiveRecord::Migration
  def self.up
    add_attachment :banners, :image
  end

  def self.down
    remove_attachment :banners, :image
  end
end
