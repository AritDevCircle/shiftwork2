class AddWorkerIdToShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :shifts, :worker_id, :integer
  end
end
