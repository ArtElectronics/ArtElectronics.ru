module MainImage
  extend ActiveSupport::Concern

  included do
    attr_accessor :main_image_need_to_be_processed
    before_save   :main_image_need_to_be_processed?

    before_save   :main_image_generate_file_name, if: ->(o) { main_image? && o.main_image_updated_at_changed? }
    after_commit  :main_image_build_variants

    has_attached_file :main_image,
                      default_url: "/default_images/main_image/:style/missing.jpg",
                      path:        ":rails_root/public/uploads/storages/:klass/:id/main_image/:style/:filename",
                      url:         "/uploads/storages/:klass/:id/main_image/:style/:filename"

    do_not_validate_attachment_file_type :main_image
  end

  def main_image_need_to_be_processed?
    self.main_image_need_to_be_processed = main_image_updated_at_changed?
    nil
  end

  def main_image_generate_file_name
    attachment = self.main_image
    file_name  = attachment.instance_read(:file_name)
    file_name  = "main-image." + TheStorages.file_ext(file_name) if !defined?(DB_MOVING)
    attachment.instance_write :file_name, file_name
  end

  def main_image_build_variants
    if main_image_need_to_be_processed
      src     = main_image.path
      base    = main_image.path :base
      preview = main_image.path :preview

      create_path_for_file base
      create_path_for_file preview

      manipulate({ src: src, dest: base, larger_side: 1024}) do |image, opts|
        image = auto_orient image
        image = strip image
        image = biggest_side_not_bigger_than(image, opts[:larger_side])
        image = to_rect image, 270, 210
        image
      end

      manipulate({ src: src, dest: preview, larger_side: 300}) do |image, opts|
        image = auto_orient image
        image = strip image
        image = biggest_side_not_bigger_than(image, opts[:larger_side])
        image = to_square image, 100
        image
      end

      # recalculate src size & save
      self.main_image_need_to_be_processed = false
    end
  end

  def main_image_crop_270x210 params
    crop_params = params[:crop].symbolize_keys

    src  = main_image.path
    dest = main_image.path :base

    manipulate({ src: src, dest: dest }.merge(crop_params)) do |image, opts|
      scale = image[:width].to_f / opts[:img_w].to_f
      image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], scale
      image = strict_resize image, 270, 210
      image
    end

    main_image.url(:base, timestamp: false)
  end

  def main_image_crop_100x100 params
    crop_params = params[:crop].symbolize_keys

    src  = main_image.path
    dest = main_image.path :preview

    manipulate({ src: src, dest: dest }.merge(crop_params)) do |image, opts|
      scale = image[:width].to_f / opts[:img_w].to_f
      image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], scale
      image = strict_resize image, 100, 100
      image
    end

    main_image.url(:preview, timestamp: false)
  end

  def main_image_rotate
    return false unless main_image?

    src     = main_image.path
    base    = main_image.path :base
    preview = main_image.path :preview

    [src, base, preview].each do |image_path|
      manipulate({ src: image_path, dest: image_path }) do |image, opts|
        rotate_right image
      end
    end
  end

  def main_image_destroy!
    base    = main_image.path(:base).to_s
    preview = main_image.path(:preview).to_s

    destroy_file [base, preview]
    main_image.destroy

    save!
  end
end

# validates_attachment :main_image,
#   content_type: {
#     content_type: AttachedFile::IMAGE_CONTENT_TYPES,
#     message: I18n.translate('posts.validation.main_image_file_type')
#   },
#   size: {
#     in: 10.kilobytes..5.megabytes,
#     message: I18n.translate('posts.validation.main_image_file_size'),
#     if: ->{ main_image? }
#   }
#taichiman: because https://github.com/thoughtbot/paperclip#security-validations. Но работает и без этого валидатора.
# file_name: {
#   :matches => [/gif\Z/, /png\Z/, /jpe?g\Z/, /bmp\Z/],
#   message: I18n.translate('posts.validation.main_image_file_name') }
