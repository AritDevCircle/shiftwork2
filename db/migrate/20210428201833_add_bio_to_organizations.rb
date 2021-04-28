class AddBioToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :bio, :string
  end
end
