class AddBioToWorkers < ActiveRecord::Migration[6.0]
  def change
    add_column :workers, :bio, :string
  end
end
