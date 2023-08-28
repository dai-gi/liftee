# == Schema Information ==
#
# Table name:   projects
# id            :bigint      null: false    PK
# name          :string      null: false
# start_date    :date        null: false
# end_date      :date        null: false
# status        :integer     null: false    default: 0
# overview      :string
# created_at    :datetime    null: false    precision: 6
# updated_at    :datetimen   null: false    precision: 6

class Project < ApplicationRecord
  belongs_to :client
  has_many :sheet, dependent: :destroy

  enum status: { pending: 0, start: 1, end: 2 }

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_date", "id", "name", "overview", "start_date", "status", "updated_at", "client_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["clients"]
  end
end
