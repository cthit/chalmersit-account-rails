class AddAuthTokenToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :auth_token, :string
  end
end
