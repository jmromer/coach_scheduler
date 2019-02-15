# frozen_string_literal: true

class Appointment < ApplicationRecord
  include LocalizationMixin

  belongs_to :coach, counter_cache: true
  validates :coach, presence: true
  validates :start_dt, presence: true
  validates :end_dt, presence: true

  alias to_s to_localized_string
end
