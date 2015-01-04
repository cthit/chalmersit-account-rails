class UsersController < ApplicationController
  before_filter :find_model

  def index
    @users = User.all
  end

  def show

  end

  def edit

  end

  def update
    if @user.update_attributes(ldap_user_params)
      redirect_to me_path, notice: 'Ändringarna sparades'
    else
      render :edit
    end
  end

  private
    def find_model
      @db_user = current_user
      @user = @db_user.ldap_user
    end

    def ldap_user_params
      params.require(:ldap_user).permit(:nickname, :mail, :gn, :sn, :preferredLanguage, :loginShell)
    end
end
