class Blog < ActiveRecord::Base
  acts_as_taggable_on :names, :words, :titles
  include BasePublication
end
