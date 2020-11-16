class CreateJoinTableProjectCurricularComponent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :curricular_components
  end
end
