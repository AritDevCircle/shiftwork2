class Shift < ApplicationRecord
  belongs_to :organization

  validates :shift_open, presence: true
  validates :shift_role, presence: true
  validates :shift_description, presence: true, length: { minimum: 10 }
  validates :shift_start, presence: true
  validates :shift_end, presence: true
  validates :shift_pay, presence: true, numericality: { greater_than_or_equal_to: 0,  only_integer: true }

  validate :shift_end_after_start

  private

  def shift_end_after_start  
    if :shift_end < :shift_start
      errors.add(:shift_end, "must occur AFTER the shift start date & time") 
    end
  end
end
