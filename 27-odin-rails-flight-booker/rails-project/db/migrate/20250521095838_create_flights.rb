class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights do |t|
      t.references :departing_airport, null: false, foreign_key: { to_table: :airports }
      t.references :arriving_airport, null: false, foreign_key: { to_table: :airports }
      t.datetime :start, null: false
      t.time :duration, null: false

      t.timestamps
    end
  end
end
