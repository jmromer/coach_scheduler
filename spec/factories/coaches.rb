# frozen_string_literal: true

FactoryBot.define do
  factory :coach do
    sequence(:name) { |n| "Coach #{n}" }
    utc_offset { 0 }

    factory :coach_with_availabilities do
      transient do
        availabilities_count { 2 }
      end

      after(:create) do |coach, evaluator|
        create_list(:availability, evaluator.availabilities_count, coach: coach)
      end
    end

    factory :coach_with_appointments do
      transient do
        appointments_count { 2 }
      end

      after(:create) do |coach, evaluator|
        create_list(:appointment, evaluator.appointments_count, coach: coach)
      end
    end
  end

  trait :eastern_time do
    utc_offset { -5 }
  end
end
