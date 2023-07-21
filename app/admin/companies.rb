ActiveAdmin.register Company do
  permit_params :name, :email, :phone_number
end
