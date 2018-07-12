class CreateJoinTableActivitySequenceAxis < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activity_sequences, :axes
  end
end
