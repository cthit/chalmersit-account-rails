class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController
  before_filter :ensure_admin

  def show
    super
    @key_groups = @keys.group_by{|k| k.partition('_').first }
    render 'admins/configurable/show'
  end
end
