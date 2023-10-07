ActiveAdmin.register Project do
  permit_params :name, :start_date, :end_date, :status, :overview, :client_id
end
