class CreateJoinTableProjectParticipant < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :participants
  end
end
