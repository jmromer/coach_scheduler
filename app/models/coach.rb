# frozen_string_literal: true

class Coach < ApplicationRecord
  validates :name, presence: true
  validates :utc_offset, presence: true

  has_many :appointments, dependent: :nullify
  has_many :availabilities, dependent: :destroy

  def to_s
    name
  end
end
