# == Schema Information ==
#
# Table name:   clients
# id            :bigint      null: false    PK
# name          :string      null: false
# email         :string      null: false
# phone_number  :string      null: false
# remarks       :string
# created_at    :datetime    null: false    precision: 6
# updated_at    :datetimen   null: false    precision: 6
# company_id    :integer                    FK

class Client < ApplicationRecord
  belongs_to :company
  has_many :projects, dependent: :destroy

  VALID_EMAIL_REGEX = /\A(?!.*(--|\.-|-\.│\s@))[a-z+-.]+@(?!.*(--|\.-|-\.│\s@))[a-z.]+\.(?!.*(--|\.-|-\.│\s@))[a-z]+\z/
  VALID_PHONE_NUMBER_REGEX = /\A0\d{9,10}\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone_number, presence: true, uniqueness: true, format: { with: VALID_PHONE_NUMBER_REGEX }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "email", "phone_number", "remarks", "created_at", "updated_at", "company_id", "projects_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["company", "project"]
  end
end