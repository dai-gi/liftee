FactoryBot.define do
  factory :task do
    trader_name { "MyString" }
    name { "MyString" }
    work_place { "MyString" }
    start_datetime { "2023-09-09 07:17:50" }
    end_datetime { "2023-09-09 07:17:50" }
    vehicles { "MyString" }
    notes { "MyString" }
    status { "" }
    sheet_id { nil }
  end
end
