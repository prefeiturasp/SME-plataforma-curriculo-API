class CreateJoinTableProjectAdvisor < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :advisors
  end
end
