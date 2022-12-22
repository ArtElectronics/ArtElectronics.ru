class MetaData < ActiveRecord::Base
  include TheSimpleSort::Base
  include ThePagination::Base
  belongs_to :holder, polymorphic: true
end
