class Role < ActiveRecord::Base
  include TheRole::Role
  include TheNotification::LocalizedErrors
end
