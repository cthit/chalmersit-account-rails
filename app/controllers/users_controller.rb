class UsersController < ApplicationController
  before_filter :find_model

  def index
    @users = User.all
  end

  def show

  end


  private
  def find_model
    @db_user = current_user
    @user = @db_user.ldap_user
  end
end
