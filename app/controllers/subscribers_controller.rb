class SubscribersController < ApplicationController
  def add
    # https://us9.admin.mailchimp.com/account/api/
    # http://kb.mailchimp.com/lists/managing-subscribers/find-your-list-id

    status, data = MailChimpModel.add params[:email]
    return render json: data if status == :ok
    render json: data, status: 422
  end
end
