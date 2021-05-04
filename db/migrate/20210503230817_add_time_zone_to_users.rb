class AddTimeZoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :timezone, :string, default: "UTC", null: false
  end
end
