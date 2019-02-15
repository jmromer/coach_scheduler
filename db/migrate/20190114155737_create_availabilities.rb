# frozen_string_literal: true

class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.datetime :start_dt, null: false, index: true
      t.datetime :end_dt, null: false, index: true
      t.belongs_to :coach,
                   null: false,
                   foreign_key: true,
                   on_delete: :cascade,
                   index: true

      t.timestamps
    end
  end
end
