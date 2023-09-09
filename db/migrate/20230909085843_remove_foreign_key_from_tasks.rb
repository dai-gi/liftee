class RemoveForeignKeyFromTasks < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :tasks, :sheet_ids
  end
end
