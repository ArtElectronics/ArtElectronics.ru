class Post < ActiveRecord::Base
  acts_as_taggable_on :names, :words, :titles
  include BasePublication

  # relations
  has_many :authorships
  has_many :authors, through: :authorships

  def future_type
    "application/x-shockwave-flash"
  end

  def future_text?
    attached_files.map(&:attachment_content_type).include? future_type
  end

  def future_text
    attached_files.where(attachment_content_type: future_type).first.url
  end
end
