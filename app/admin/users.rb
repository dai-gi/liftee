ActiveAdmin.register User do
  permit_params :name, :syllabic_characters, :email, :phone_number, :password, :password_confirmation, :role, :company_id

  form do |f|
    f.inputs "User Details" do
      f.input :company_id, as: :select, collection: Company.all.map { |company| [company.name, company.id] }, label: 'Company Name'
      f.input :name
      f.input :syllabic_characters
      f.input :email
      f.input :phone_number
      f.input :password
      f.input :password_confirmation
      f.input :role
    end
    f.actions
  end
end