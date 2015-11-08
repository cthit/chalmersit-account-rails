class AddPushClientToServiceData < ActiveRecord::Migration
  def change
    add_column :service_data, :push_client, :string
  end
end
