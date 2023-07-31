class Client < ApplicationRecord
  VALID_EMAIL_REGEX = /\A(?!.*(--|\.-|-\.│\s@))[a-z+-.]+@(?!.*(--|\.-|-\.│\s@))[a-z.]+\.(?!.*(--|\.-|-\.│\s@))[a-z]+\z/
  VALID_PHONE_NUMBER_REGEX = /\A0\d{9,10}\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone_number, presence: true, uniqueness: true, format: { with: VALID_PHONE_NUMBER_REGEX }
end
