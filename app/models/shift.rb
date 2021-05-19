class Shift < ApplicationRecord
  belongs_to :organization

  validates_inclusion_of :shift_open, in: [true, false]
  validates :shift_role, presence: true
  validates :shift_description, presence: true, length: { minimum: 10 }
  validates :shift_start, presence: true
  validates :shift_end, presence: true
  validates :shift_pay, presence: true, numericality: { greater_than_or_equal_to: 0,  only_integer: true }
  
  validate :shift_not_too_short
  validate :shift_ends_after_start
  validate :shift_start_before_current_date?

  def shift_org_name
    Organization.where(id: self.organization_id).first.org_name
  end

  def shift_worker_name
    worker = Worker.where(id: self.worker_id).first
    if worker
      return "#{worker.first_name} #{worker.last_name}" 
    end
  end

  def filled_by(user)
    Worker.where(id: self.worker_id).first.user_id == user.id
  end

  def can_be_dropped?
    ((self.shift_start - Time.now) / 1.hour) > 24
  end

  private

  def shift_not_too_short
    return if self.shift_start.blank? || self.shift_end.blank?

    if ((self.shift_end - self.shift_start) / 1.hour) < 1
      errors.add(:shift, "duration must be at least 1 hour!")
    end
  end

  def shift_ends_after_start
    return if self.shift_start.blank? || self.shift_end.blank?
    
    if self.shift_end < self.shift_start
      errors.add(:shift, "cannot end before it starts!")
    end
  end

  def shift_start_before_current_date?
    if shift_start < Time.zone.now - 100
      errors.add :shift_start, "cannot be in the past" 
    elsif shift_start < Time.zone.now + 3600
      errors.add :shift_start, "must be created at least an hour before start" 
    end
  end

end
