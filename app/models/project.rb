class Project < ApplicationRecord

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_date", "id", "name", "overview", "start_date", "status", "updated_at"]
  end
end
