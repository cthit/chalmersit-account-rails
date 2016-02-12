class CreateServiceData < ActiveRecord::Migration
  def change
    create_table :service_data do |t|
      t.references :user, index: true
      t.string :send_to
      t.string :device
      t.references :subscribable_types, index: true

      t.timestamps null: false
    end
    add_foreign_key :service_data, :users
    add_foreign_key :service_data, :subscribable_types
  end
end
