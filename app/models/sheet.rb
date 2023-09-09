class Sheet < ApplicationRecord
  belongs_to :project
  has_many :task, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "project_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["projects"]
  end
end
