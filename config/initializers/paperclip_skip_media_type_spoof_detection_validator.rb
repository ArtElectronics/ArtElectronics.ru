# config/initializers/paperclip_skip_media_type_spoof_detection_validator.rb

require 'active_model/validations/presence'

# class AttachedFile < ActiveRecord::Base
#   validates_attachment_content_type :attachment, content_type: /.*/
#
#   def skip_spoof_detection_list
#     %w[ attachment ]
#   end
# end

module Paperclip
  module Validators
    class MediaTypeSpoofDetectionValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if skip_list = record.try(:skip_spoof_detection_list)
          return true if skip_list.include? attribute.to_s
        end

        adapter = Paperclip.io_adapters.for(value)
        if Paperclip::MediaTypeSpoofDetector.using(adapter, value.original_filename).spoofed?
          record.errors.add(attribute, :spoofed_media_type)
        end
      end
    end
  end
end
