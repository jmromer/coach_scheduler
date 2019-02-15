# frozen_string_literal: true

module LocalizationMixin
  def start_dt_local
    start_dt.in_time_zone(coach.utc_offset)
  end

  def end_dt_local
    end_dt.in_time_zone(coach.utc_offset)
  end

  def to_localized_string
    date = start_dt_local.strftime("%A %b %e, %Y")
    start_time = start_dt_local.strftime("%l:%M %P")
    end_time = end_dt_local.strftime("%l:%M %P")

    "#{date}: #{start_time} - #{end_time} (UTC#{coach.utc_offset})"
  end

  def localized_label
    date = start_dt_local.strftime("%A, %B %e").strip
    start_time = start_dt_local.strftime("%l:%M%P").strip
    end_time = end_dt_local.strftime("%l:%M%P").strip

    "#{date}, from #{start_time} to #{end_time}"
  end
end
