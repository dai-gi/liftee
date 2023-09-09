ActiveAdmin.register Task do
  permit_params :trader_name, :name, :work_place, :start_datetime, :end_datetime, :vehicles, :notes, :status, :sheet_id
end
