class AddDevicesToServiceData < ActiveRecord::Migration
  def change
    add_column :service_data, :devices, :string
  end
end
