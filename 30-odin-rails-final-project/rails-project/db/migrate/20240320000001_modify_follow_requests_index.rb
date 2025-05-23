class ModifyFollowRequestsIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :follow_requests, %i[follower_id source_id]
    add_index :follow_requests, %i[follower_id source_id status], unique: true,
      where: "status = 'pending'", name: "index_follow_requests_on_follower_source_pending"
  end
end
