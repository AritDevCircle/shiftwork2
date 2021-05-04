class Worker < ApplicationRecord
  belongs_to :user

  validates :first_name, presence: true, uniqueness: { case_sensitive: false }
  validates :last_name, presence: true, uniqueness: { case_sensitive: false }
  validates :worker_city, presence: true
  validates :worker_state, presence: true

  def worker_full_name
    "#{self.first_name} #{self.last_name}"
  end

  def completed_shifts
    Shift.where(worker_id: self.id).count
  end

  private
end
