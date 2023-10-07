class RenameSheetIdColumnInTasks < ActiveRecord::Migration[6.1]
  def change
    rename_column :tasks, :sheet_id_id, :sheet_id
  end
end
