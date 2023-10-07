class RemoveForeignKeyFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :users, :company_ids
  end
end
