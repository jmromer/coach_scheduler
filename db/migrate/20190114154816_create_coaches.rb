# frozen_string_literal: true

class CreateCoaches < ActiveRecord::Migration[5.2]
  def change
    create_table :coaches do |t|
      t.string :name, null: false
      t.integer :utc_offset, null: false
      t.integer :availabilities_count, default: 0, null: false
      t.integer :appointments_count, default: 0, null: false

      t.timestamps
    end
  end
end
