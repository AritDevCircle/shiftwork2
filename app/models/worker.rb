class Worker < ApplicationRecord
  belongs_to :user

  validates :first_name, presence: true, uniqueness: { case_sensitive: false }
  validates :last_name, presence: true, uniqueness: { case_sensitive: false }
  validates :worker_city, presence: true
  validates :worker_state, presence: true

  private
end
