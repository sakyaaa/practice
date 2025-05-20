class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :date, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
