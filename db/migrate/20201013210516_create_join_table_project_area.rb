class CreateJoinTableProjectArea < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :areas
  end
end
