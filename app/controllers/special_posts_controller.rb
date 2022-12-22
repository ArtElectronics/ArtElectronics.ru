class SpecialPostsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :tatlin_postcard

  def tatlin_postcard
    img_data = params[:image].gsub "data:image/png;base64,", ''

    file_name = Digest::MD5.hexdigest img_data
    file_path = "#{ Rails.root }/public/special_posts/tatlin_postcards/#{ file_name }.png"

    File.open(file_path, 'wb') do|f|
      f.write(Base64.decode64 img_data)
    end

    SpecialPostsMailer.tatlin_postcard(params[:email], params[:name], file_path).deliver

    render layout: false, template: "special_posts/tatlin_postcard_sended"
  end
end
