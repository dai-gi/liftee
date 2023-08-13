class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.smallint :status, null: false, default: 0
      t.string :overview

      t.timestamps
    end
  end
end
