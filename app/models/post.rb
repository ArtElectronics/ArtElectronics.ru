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

  #TODO может быть ввести поле в attached_files, в котором однозначно указать тип swf, а не вычислять его по имени файла? 
  def future_type? type
    if future_text?
      name = self.attached_files.where(attachment_content_type:future_type).first.attachment_file_name      
      
      case type
      when :swf
        return true if name=~/^swf-\d+/        
      when :swf_see
        return true if name=~/^swf-see/
      end
    end
    false
  end
end
