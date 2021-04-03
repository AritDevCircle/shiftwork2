class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :org_name
      t.string :org_description
      t.string :org_address
      t.string :org_city
      t.string :org_state
      t.integer :user_id

      t.timestamps
    end
  end
end
