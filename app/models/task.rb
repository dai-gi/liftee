# == Schema Information ==
#
# Table name:   tasks
# id            :bigint      null: false    PK
# trader_name   :string      null: false
# name          :string      null: false
# start_datetime    :date        null: false
# end_datetime      :date        null: false
# vehicles      :string      null: false
# notes         :string
# status        :integer     null: false    default: 0
# created_at    :datetime    null: false    precision: 6
# updated_at    :datetimen   null: false    precision: 6

class Task < ApplicationRecord
  belongs_to :sheet

  enum status: { pending: 0, start: 1, end: 2 }

  validates :trader_name, presence: true
  validates :name, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_datetime", "id", "name", "notes", "sheet_id", "start_datetime", "status", "trader_name", "updated_at", "vehicles", "work_place"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["sheets"]
  end
end
