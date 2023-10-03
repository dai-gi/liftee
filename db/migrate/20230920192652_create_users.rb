class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :syllabic_characters, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.references :company_id, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, [:email], unique: true
  end
end
