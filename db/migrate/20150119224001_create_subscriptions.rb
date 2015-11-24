class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.string :category
      t.references :application, index: true
      t.references :service_data, index: true

      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
    add_foreign_key :subscriptions, :applications
    add_foreign_key :subscriptions, :service_data
  end
end
