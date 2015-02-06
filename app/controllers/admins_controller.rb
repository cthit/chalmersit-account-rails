class AdminsController < ApplicationController
  include ConfigurableEngine::ConfigurablesController
  before_filter :ensure_admin

  def show
  end

  def edit
  end

  def update
  end

  def index
  end
end
