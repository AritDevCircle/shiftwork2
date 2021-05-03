class Shift < ApplicationRecord
  belongs_to :organization

  validates_inclusion_of :shift_open, in: [true, false]
  validates :shift_role, presence: true
  validates :shift_description, presence: true, length: { minimum: 10 }
  validates :shift_start, presence: true
  validates :shift_end, presence: true
  validates :shift_pay, presence: true, numericality: { greater_than_or_equal_to: 0,  only_integer: true }

  # validate :shift_end_after_start

  def shift_org_name
    Organization.where(id: self.organization_id).first.org_name
  end

  def shift_worker_name
    worker = Worker.where(id: self.worker_id).first
    return "#{worker.first_name} #{worker.last_name}"
  end

  private

  def shift_end_after_start  
    if :shift_end < :shift_start
      errors.add(:shift_end, "must occur AFTER the shift start date & time") 
    end
  end
end
