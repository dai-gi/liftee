# == Schema Information ==
#
# Table name:   tasks
# id            :bigint      null: false    PK
# trader_name   :string      null: false
# name          :string      null: false
# start_date    :date        null: false
# end_date      :date        null: false
# vehicles      :string      null: false
# notes         :string
# status        :integer     null: false    default: 0
# created_at    :datetime    null: false    precision: 6
# updated_at    :datetimen   null: false    precision: 6

class Task < ApplicationRecord
  belongs_to :sheet_id

  enum status: { pending: 0, start: 1, end: 2 }

  validates :trader_name, presence: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true
end
