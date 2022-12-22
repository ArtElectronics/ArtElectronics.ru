# = raw Banner.for_location('left-top-240-400').published.first.try(:insert)

class Banner < ActiveRecord::Base
  include ::TheBanners::Model

  def self.locations
    %w(right-top-240-400 top-728-90)
  end
end
