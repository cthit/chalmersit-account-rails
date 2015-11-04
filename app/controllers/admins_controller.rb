class AdminsController < ApplicationController
  include ConfigurableEngine::ConfigurablesController
  before_filter :ensure_admin
  after_action :verify_authorized

  def show
  end

  def edit
  end

  def update
  end

  def index
  end

  def mail
    puts "WHO \n\n\n\n\n"
  end
end
