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

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_date", "id", "name", "overview", "start_date", "status", "updated_at"]
  end
end
