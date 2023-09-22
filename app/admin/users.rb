ActiveAdmin.register User do
  permit_params :name, :syllabic_characters, :email, :phone_number, :password_digest, :role, :company_id
end