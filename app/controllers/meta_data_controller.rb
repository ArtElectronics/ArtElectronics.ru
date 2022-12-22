class MetaDataController < ApplicationController
  layout 'bootstrap_default'

  before_action :user_require
  before_action :role_required

  before_action :set_meta_data,  only: %w[ edit update ]
  before_action :owner_required, only: %w[ edit update destroy ]

  def index
    @meta_datum = MetaData.simple_sort(params, :updated_at).pagination(params)
  end

  def edit; end

  def update
    @meta_data.update(meta_data_params)
    redirect_to url_for([:edit, @meta_data]), notice: "Мета Данные установлены"
  end

  private

  def set_meta_data
    @meta_data = MetaData.find params[:id]
    @holder = @meta_data.holder

    @owner_check_object = @meta_data
  end

  def meta_data_params
    params.require(:meta_data).permit(%w[
      title keywords description author
      og_url og_type og_image og_title og_description og_site_name
    ])
  end
end
