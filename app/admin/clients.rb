ActiveAdmin.register Client do
  permit_params :name, :email, :phone_number, :remarks, :company_id
end
