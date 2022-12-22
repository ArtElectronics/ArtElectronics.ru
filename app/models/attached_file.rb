class AttachedFile < ActiveRecord::Base
  include TheImage
  include TheNotification::LocalizedErrors

  def skip_spoof_detection_list
    %w[ attachment ]
  end

  IMAGE_EXTS = %w[ jpg jpeg pjpeg png x-png gif bmp ]
  IMAGE_CONTENT_TYPES = IMAGE_EXTS.map{ |e| "image/#{e}" }

  attr_accessor :image_processing

  acts_as_nested_set scope: [:user_id, :storage_id, :storage_type]
  include TheSortableTree::Scopes

  belongs_to :user
  belongs_to :storage, polymorphic: true

  has_attached_file :attachment,
                    default_url: TheStorages.config.default_url,
                    path:        TheStorages.config.attachment_path,
                    url:         TheStorages.config.attachment_url

  validates_attachment_size :attachment,
    in: TheStorages.config.file_min_size..TheStorages.config.file_max_size,
    message: I18n.translate('the_storages.validation.attachment_file_size')

  validates :attachment_file_name,
    uniqueness: {
      scope: [:user_id, :storage_type, :storage_id],
      message: I18n.translate('the_storages.validation.uniq_attachment_file_name')
    }

  # this validation should be turn off by hook in initializers
  validates_attachment_content_type :attachment, content_type: /.*/

  before_validation :generate_file_name, on: :create
  before_create     :set_processing_flags
  after_create      :recalculate_storage_counters
  after_commit      :attachment_processing, on: [:create, :update]
  after_destroy     :recalculate_storage_counters

  scope :images, ->{ where(attachment_content_type: IMAGE_CONTENT_TYPES)  }

  # Life cycle
  def generate_file_name
    file_name = attachment.instance_read(:file_name).slugged_filename
    attachment.instance_write :file_name, file_name
  end

  def set_processing_flags
    if is_image?
      self.processing       = :processing
      self.image_processing = true
    end
  end

  def recalculate_storage_counters
    storage.recalculate_storage_counters!
  end

  def attachment_processing
    if is_image? && image_processing
      self.image_processing = false

      create_image_versions
      recalculate_storage_counters
    else
      recalculate_storage_counters
    end
  end

  def destroy_versions
    base    = path(:base).to_s
    preview = path(:preview).to_s
    destroy_file [base, preview]
  end

  # HELPERS
  def file_css_class
    'f_' + TheStorages.file_ext(attachment_file_name)
  end

  def title
    attachment_file_name
  end

  def file_name
    TheStorages.file_name(attachment_file_name)
  end

  def content_type
    attachment_content_type
  end

  def mb_size
    FileSizeHelper.mb_size(attachment_file_size)
  end

  def path style = nil
    attachment.path(style)
  end

  def url style = nil, opts = {}
    url = attachment.url(style, opts)
    return url unless opts[:nocache]
    rnd = (rand*1000000).to_i.to_s
    url =~ /\?/ ? (url + rnd) : (url + '?' + rnd)
  end

  # BASE HELPERS
  def is_image?
    IMAGE_EXTS.include? TheStorages.file_ext(attachment_file_name)
  end

  # CALLBACKS

  def create_image_versions
    src     = path
    base    = path :base
    preview = path :preview

    create_path_for_file base
    create_path_for_file preview

    manipulate({ src: src, dest: src }) do |image, opts|
      image = auto_orient image
      image = strip image
      image
    end

    manipulate({ src: src, dest: base, larger_side: 1024 }) do |image, opts|
      biggest_side_not_bigger_than(image, opts[:larger_side])
    end

    manipulate({ src: base, dest: preview }) do |image, opts|
      to_square image, 100
    end

    FileUtils.chmod 0644, base
    FileUtils.chmod 0644, preview
  end

  # job = DelayedImageProcessor.new(self)
  # job.perform
  # Delayed::Job.enqueue job, queue: :image_processing, run_at: Proc.new { 10.seconds.from_now }
end
