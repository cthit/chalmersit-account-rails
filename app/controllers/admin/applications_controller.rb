class Admin::ApplicationsController < ApplicationController
  before_filter :ensure_admin
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Application.all
    render 'admins/applications/index'
  end
  def show
    render 'admins/applications/show'
  end
  def edit
    render 'admins/applications/edit'
  end
  def update
    if @application.update_attributes(application_params)
      render 'admins/applications/show'
    else
      render 'admins/applications/edit'
    end
  end
  def new
    @application = Application.new
    render 'admins/applications/new'
  end
  def create
    @application = Application.new(application_params)
    if @application.save
      render 'admins/applications/show'
    else
      render 'admins/applications/new'
    end
  end
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to admin_applications_url, notice: 'The group was deleted' }
      format.json { head :no_content }
    end
  end
private
  def set_application
    @application = Application.find(params[:id])
  end
  def application_params
    params.require(:application).permit(:name, :description, :avatar)
  end
end
