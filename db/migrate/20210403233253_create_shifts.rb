class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.boolean :shift_open
      t.string :shift_role
      t.string :shift_description
      t.datetime :shift_start
      t.datetime :shift_end
      t.integer :shift_pay
      t.integer :org_id

      t.timestamps
    end
  end
end
