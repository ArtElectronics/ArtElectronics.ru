module FutureTextMethods
  extend ActiveSupport::Concern

  included do
    def future_type
      "application/x-shockwave-flash"
    end

    def pdf_type
      "application/pdf"
    end

    def has_article_variants?
      has_future_text? || has_pdf?
    end

    def has_future_text?
      attached_files.map(&:attachment_content_type).include? future_type
    end

    def has_pdf?
      attached_files.map(&:attachment_content_type).include? pdf_type
    end

    def future_text
      attached_files.where(attachment_content_type: future_type).first.try(:url)
    end

    def pdf_file
      attached_files.where(attachment_content_type: pdf_type).first.try(:url)
    end

    # TODO может быть ввести поле в attached_files,
    # в котором однозначно указать тип swf
    # а не вычислять его по имени файла?
    def get_future_type
      if has_future_text?
        name = self.attached_files.where(attachment_content_type: future_type).first.try(:attachment_file_name)

        return :swf     if name =~ /^swf-\d+/
        return :swf_see if name =~ /^swf-see/
        return :swf     # if type unknown
      end
    end
  end
end
