class CreateWorkers < ActiveRecord::Migration[6.0]
  def change
    create_table :workers do |t|
      t.string :first_name
      t.string :last_name
      t.string :worker_city
      t.string :worker_state
      t.integer :user_id

      t.timestamps
    end
  end
end
