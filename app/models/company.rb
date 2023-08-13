class Company < ApplicationRecord
  has_many :clients, dependent: :destroy

  VALID_EMAIL_REGEX = /\A(?!.*(--|\.-|-\.│\s@))[a-z+-.]+@(?!.*(--|\.-|-\.│\s@))[a-z.]+\.(?!.*(--|\.-|-\.│\s@))[a-z]+\z/
  VALID_PHONE_NUMBER_REGEX = /\A0\d{9,10}\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone_number, presence: true, uniqueness: true, format: { with: VALID_PHONE_NUMBER_REGEX }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "email", "phone_number", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["clients"]
  end
end
