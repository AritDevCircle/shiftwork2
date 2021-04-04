class Organization < ApplicationRecord
  belongs_to :user
  has_many :shifts

  validates :org_name, presence: true
  validates :org_description, presence: true, length: { minimum: 10 }
  validates :org_address, presence: true
  validates :org_city, presence: true
  validates :org_state, presence: true
end
