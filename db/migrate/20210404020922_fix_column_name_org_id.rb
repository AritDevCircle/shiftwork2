class FixColumnNameOrgId < ActiveRecord::Migration[6.0]
  def change
    rename_column :shifts, :org_id, :organization_id
  end
end
