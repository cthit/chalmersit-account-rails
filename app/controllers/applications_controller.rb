class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show]

  def index
    @applications = Application.all
    render 'applications/index'
  end
  def show
    render 'applications/show'
  end
private
  def set_application
    @application = Application.find(params[:id])
  end
end
