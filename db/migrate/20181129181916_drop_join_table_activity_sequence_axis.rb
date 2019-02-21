class DropJoinTableActivitySequenceAxis < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :activity_sequences, :axes
  end
end
