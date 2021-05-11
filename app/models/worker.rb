class Worker < ApplicationRecord
  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :worker_city, presence: true
  validates :worker_state, presence: true

  def worker_full_name
    "#{self.first_name} #{self.last_name}"
  end

  private
end
