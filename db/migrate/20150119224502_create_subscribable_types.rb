class CreateSubscribableTypes < ActiveRecord::Migration
  def change
    create_table :subscribable_types do |t|
      t.references :application, index: true
      t.string :name, index: true
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :subscribable_types, :applications
  end
end
