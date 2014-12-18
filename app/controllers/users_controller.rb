class UsersController < ApplicationController
  before_filter :find_model

  def index
    @users = User.all
  end

  def show

  end


  private
  def find_model
    @user = current_user
  end
end
