class CreateSheets < ActiveRecord::Migration[6.1]
  def change
    create_table :sheets do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
