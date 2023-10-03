class User < ApplicationRecord
  has_secure_password

  belongs_to :company

  enum role: { general: 0, project_manager: 1, admin: 2 }

  validates :name, presence: true
  validates :syllabic_characters, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :role, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "syllabic_characters", "email", "phone_number", "password_digest", "role", "company_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["companies"]
  end
end
