class PagesController < ApplicationController
  include PublicationController

  def index
    super
    render template: 'publications/index'
  end

  def show
    super
    render template: 'publications/show'
  end
end
