class User < ApplicationRecord
  belongs_to :company

  enum role: { general: 0, project_manager: 1, admin: 2 }

  validates :name, presence: true
  validates :syllabic_characters, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :password_digest, presence: true
  validates :role, presence: true
end
