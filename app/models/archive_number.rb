class ArchiveNumber < ActiveRecord::Base

  has_attached_file :cover, 
                    styles: { :big => "190x260#", :thumb => "95x122#" }, 
                    default_url: "/default_images/cover/:style/missing.jpg",
                    path: ":rails_root/public/uploads/storages/archive_number/:id/:style/:filename",
                    url: "/uploads/storages/archive_number/:id/:style/:filename"

  do_not_validate_attachment_file_type :cover

end
