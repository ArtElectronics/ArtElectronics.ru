class AttachedFilesController < ApplicationController
  include TheSortableTreeController::Rebuild

  before_action :find_storage, only: %w[ create ]

  def create
    @new_file = @storage.attached_files.new(attachment: params[:file])

    if @new_file.save
      render 'the_storages/create.success'
    else
      render 'the_storages/create.errors'
    end
  end

  def destroy
    attachment = AttachedFile.find(params[:id])
    attachment.destroy_versions
    attachment.destroy
    redirect_to [request.referer, :files].join('#')
  end

  private

  def find_storage
    id    = params[:storage_id]
    klass = params[:storage_type].constantize
    @storage = klass.friendly_first(id)
  end
end
