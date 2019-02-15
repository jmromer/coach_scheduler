# frozen_string_literal: true

class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :start_dt, null: false, index: true
      t.datetime :end_dt, null: false, index: true
      t.belongs_to :coach,
                   null: false,
                   foreign_key: true,
                   on_delete: :nullify,
                   index: true

      t.timestamps
    end
  end
end
