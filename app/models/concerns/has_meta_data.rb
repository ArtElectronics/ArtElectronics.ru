module HasMetaData
  extend ActiveSupport::Concern

  included do
    after_create :create_meta_data
    has_one :meta_data, as: :holder
  end
end
