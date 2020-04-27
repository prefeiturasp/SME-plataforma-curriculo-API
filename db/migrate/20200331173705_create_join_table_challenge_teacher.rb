class CreateJoinTableChallengeTeacher < ActiveRecord::Migration[5.2]
  def change
    create_join_table :challenges, :teachers do |t|
      t.index [:challenge_id, :teacher_id]
      t.index [:teacher_id, :challenge_id]
    end
  end
end
