class ArchiveNumbersController < ApplicationController
  layout 'bootstrap_default', except: [:index]

  before_action :set_archive_number, only: [ :edit, :update, :show, :destroy ]

  before_action :user_require
  before_action :role_required

  def index
    @archives = ArchiveNumber.all
  end

  def manage
    @archives = ArchiveNumber.all.order(id: :desc).page params[:page]
  end

  def edit; end

  def update
    if @archive.update( archive_params )
        redirect_to archive_numbers_path, notice: t('.updated')
    else
        render action: :edit
    end
  end

  def show; end

  def new
    @archive = ArchiveNumber.new
  end

  def create
    @archive = ArchiveNumber.new( archive_params )

    if @archive.save
      flash.notice = t('.created')
      redirect_to archive_numbers_path
    else
      render action: :new
    end
  end


  def destroy
    @archive.destroy
    redirect_to archive_numbers_url
  end

  private

  def set_archive_number
    @archive = ArchiveNumber.find( params[:id] )
  end

  def archive_params
    params.require(:archive_number).permit(
      :number, :year, :month, :number_in_year,
      :raw_content,
      :cover
    )
  end
end
