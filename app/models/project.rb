class Project < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_date", "id", "name", "overview", "start_date", "status", "updated_at"]
  end
end
