class Authorship < ActiveRecord::Base
  # relations
  belongs_to :author
  belongs_to :post
end
