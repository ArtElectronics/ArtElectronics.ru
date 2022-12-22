module UserAvatar
  extend ActiveSupport::Concern

  included do
    include TheImage

    before_validation :generate_avatar_name
    after_commit :avatar_original_resize

    has_attached_file :avatar, styles: {
      original: ["100%x100%", :png],
      medium:   ["100x100#",  :png],
      thumb:    ["50x50#",    :png]
    },
    default_url: "/default_images/avatar/:style/missing.png",
    path: ":rails_root/public/uploads/:class/:attachment/:id/:style/:filename",
    url:  "/uploads/:class/:attachment/:id/:style/:filename"

    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  end

  def generate_avatar_name
    if avatar.present? && changes[:avatar_updated_at]
      file_name = [SecureRandom.hex[0..10], 'png'].join '.'
      avatar.instance_write :file_name, file_name
    end
  end

  def avatar_crop params
    crop_params = params[:crop].symbolize_keys

    src  = avatar.path
    dest = avatar.path :medium

    manipulate({ src: src, dest: dest }.merge(crop_params)) do |image, opts|
      scale = image[:width].to_f / opts[:img_w].to_f
      image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], scale
      image = strict_resize image, 100, 100
      image
    end

    avatar.url(:medium, timestamp: false)
  end

  def avatar_original_resize
    if avatar.present? && previous_changes[:avatar_updated_at]
      src  = avatar.path
      dest = avatar.path

      manipulate({ src: src, dest: dest }) do |image, opts|
        biggest_side_not_bigger_than image, 600
      end
    end
  end
end
