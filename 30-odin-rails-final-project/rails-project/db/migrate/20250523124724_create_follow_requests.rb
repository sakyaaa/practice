class CreateFollowRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :follow_requests do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :source, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'

      t.timestamps
    end

    add_index :follow_requests, %i[follower_id source_id], unique: true
  end
end
