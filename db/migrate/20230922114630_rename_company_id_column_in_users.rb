class RenameCompanyIdColumnInUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :company_id_id, :company_id
  end
end
