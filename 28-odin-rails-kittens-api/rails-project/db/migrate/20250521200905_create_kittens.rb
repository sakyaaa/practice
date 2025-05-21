class CreateKittens < ActiveRecord::Migration[8.0]
  def change
    create_table :kittens do |t|
      t.string :name, null: false
      t.integer :age, null: false
      t.integer :cuteness, null: false
      t.integer :softness, null: false

      t.timestamps
    end

    add_index :kittens, :name, unique: true
  end
end
