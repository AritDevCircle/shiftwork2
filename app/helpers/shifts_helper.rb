module ShiftsHelper
  def in_user_timezone(time)
    time.in_time_zone(current_user.timezone).strftime("%A %B %-d, %Y - %l:%M %p")
  end
end
