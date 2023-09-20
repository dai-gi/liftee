class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :trader_name, null: false
      t.string :name, null: false
      t.string :work_place, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.string :vehicles, null: false
      t.string :notes
      t.integer :status, null: false, default: 0
      t.references :sheet_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
