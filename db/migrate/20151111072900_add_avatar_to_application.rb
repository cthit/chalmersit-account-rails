class AddAvatarToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :avatar, :string
  end
end
